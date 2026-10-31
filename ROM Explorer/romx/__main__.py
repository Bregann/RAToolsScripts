"""Run with:  python -m romx   (add --port 9000 to change the port, --no-browser to not open a browser tab)
           python -m romx --mcp   runs ROM Explorer as an MCP server for Claude instead of the web UI."""
import argparse

def main():
    ap = argparse.ArgumentParser(prog='romx', description='ROM Explorer: browse, name and annotate game code.')
    ap.add_argument('--port', type=int); ap.add_argument('--no-browser', action='store_true')
    ap.add_argument('--mcp', action='store_true', help='Run as an MCP server over stdin/stdout (for Claude)')
    a = ap.parse_args()
    if a.mcp:
        from .mcp_server import main as mcp_main; return mcp_main()
    from .server import serve
    serve(a.port, not a.no_browser)

if __name__ == '__main__':
    main()
