//HPCardGen();
BitExtractor();


static void BitExtractor()
{
    // Read the text document.
    var text = File.ReadAllLines("test.txt");

    var hex = "";

    foreach (var line in text)
    {
        if (line.StartsWith("0x"))
        {
            hex = line.Trim();
            continue;
        }

        if (line.StartsWith("bit1"))
        {
            Console.Write($"bit1({hex}) + ");
            continue;
        }

        if (line.StartsWith("bit3"))
        {
            Console.Write($"bit3({hex}) + ");
            continue;
        }

        if (line.StartsWith("bit5"))
        {
            Console.Write($"bit5({hex}) + ");
            continue;
        }

        if (line.StartsWith("bit7"))
        {
            Console.Write($"bit7({hex}) + ");
            continue;
        }
    }
}

static void HPCardGen()
{
    for (int i = 0; i < 16; i++)
    {
        if (i != 0)
        {
            if (i % 2 != 0)
            {
                continue;
            }
        }

        var ii = i + 2;
        var iii = i + 3;
        var iiii = i + 4;
        var iiiii = i + 5;
        Console.WriteLine($@"
[Bitflag] Wizard cards
bit0=Y4C{ii} card 1
bit1=Y4C{ii} card 2
bit2=Y4C{iii} card 1
bit3=Y4C{iii} card 2
bit4=Y4C{iiii} card 1
bit5=Y4C{iiii} card 2
bit6=Y4C{iiiii} card 1
bit7=Y4C{iiiii} card 2
");
        Console.WriteLine("\n");
    }
}