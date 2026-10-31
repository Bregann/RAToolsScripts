// ROM Explorer helper script for Ghidra's analyzeHeadless.
//   pre  <starts file> <thumb 0|1> : create functions at the addresses ROM Explorer found (before auto-analysis)
//   post <out json>                : decompile every function and write {"functions":[{entry,end,name,c}]}
//@category ROM Explorer
import ghidra.app.script.GhidraScript;
import ghidra.app.decompiler.DecompInterface;
import ghidra.app.decompiler.DecompileResults;
import ghidra.program.model.address.Address;
import ghidra.program.model.lang.Register;
import ghidra.program.model.listing.Function;
import ghidra.program.model.listing.FunctionIterator;
import java.io.*;
import java.math.BigInteger;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;
import java.util.*;

public class RomxExport extends GhidraScript {
    @Override
    public void run() throws Exception {
        String[] a = getScriptArgs();
        if (a.length == 0) { println("RomxExport: missing arguments"); return; }
        if (a[0].equals("pre")) pre(a); else post(a);
    }

    private final Set<Address> thumbStarts = new HashSet<>();

    private List<Address> readStarts(String path) throws IOException {
        List<Address> out = new ArrayList<>();
        if (path == null || path.isEmpty() || !Files.exists(Paths.get(path))) return out;
        for (String line : Files.readAllLines(Paths.get(path), StandardCharsets.UTF_8)) {
            line = line.trim();
            if (line.isEmpty()) continue;
            String[] parts = line.split("\\s+");
            Address ad = toAddr(Long.parseLong(parts[0], 16));
            if (ad == null) continue;
            out.add(ad);
            if (parts.length > 1 && parts[1].equals("t")) thumbStarts.add(ad);
        }
        return out;
    }

    private void pre(String[] a) throws Exception {
        List<Address> starts = readStarts(a.length > 1 ? a[1] : "");
        // thumb flag: 1 = every start is Thumb (GBA), 2 = per start ("addr t" lines, DS), 0 = none
        String tf = a.length > 2 ? a[2] : "0";
        Register tmode = currentProgram.getRegister("TMode");
        int made = 0;
        for (Address ad : starts) {
            if (monitor.isCancelled()) break;
            try {
                boolean thumb = tf.equals("1") || (tf.equals("2") && thumbStarts.contains(ad));
                if (thumb && tmode != null) currentProgram.getProgramContext().setValue(tmode, ad, ad, BigInteger.ONE);
                if (getFunctionAt(ad) == null) {
                    disassemble(ad);
                    if (createFunction(ad, null) != null) made++;
                }
            } catch (Exception e) {
                // skip addresses Ghidra can't use
            }
        }
        println("RomxExport: created " + made + " functions from " + starts.size() + " starts");
    }

    private void post(String[] a) throws Exception {
        String out = a[1];
        DecompInterface di = new DecompInterface();
        di.openProgram(currentProgram);
        int n = 0;
        try (Writer w = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(out), StandardCharsets.UTF_8))) {
            w.write("{\"functions\":[\n");
            boolean first = true;
            FunctionIterator it = currentProgram.getFunctionManager().getFunctions(true);
            while (it.hasNext() && !monitor.isCancelled()) {
                Function f = it.next();
                String c = "";
                try {
                    DecompileResults r = di.decompileFunction(f, 30, monitor);
                    if (r != null && r.decompileCompleted() && r.getDecompiledFunction() != null) c = r.getDecompiledFunction().getC();
                } catch (Exception e) {
                    c = "";
                }
                if (!first) w.write(",\n");
                first = false;
                w.write("{\"entry\":" + f.getEntryPoint().getOffset() + ",\"end\":" + f.getBody().getMaxAddress().getOffset()
                        + ",\"name\":" + js(f.getName()) + ",\"c\":" + js(c) + "}");
                n++;
                if (n % 200 == 0) println("RomxExport: decompiled " + n + " functions");
            }
            w.write("\n]}\n");
        } finally {
            di.dispose();
        }
        println("RomxExport: wrote " + n + " functions to " + out);
    }

    private static String js(String s) {
        StringBuilder b = new StringBuilder("\"");
        for (int i = 0; i < s.length(); i++) {
            char ch = s.charAt(i);
            switch (ch) {
                case '"': b.append("\\\""); break;
                case '\\': b.append("\\\\"); break;
                case '\n': b.append("\\n"); break;
                case '\r': break;
                case '\t': b.append("\\t"); break;
                default:
                    if (ch < 0x20) b.append(String.format("\\u%04x", (int) ch)); else b.append(ch);
            }
        }
        return b.append('"').toString();
    }
}
