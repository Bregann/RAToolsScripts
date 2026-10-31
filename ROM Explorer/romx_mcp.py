"""Start ROM Explorer's MCP server for Claude. The Claude desktop app runs this file (see README: Connect to Claude)."""
import os, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from romx.mcp_server import main
main()
