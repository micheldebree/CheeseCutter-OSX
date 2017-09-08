/*

Boost Software License - Version 1.0 - August 17th, 2003

Permission is hereby granted, free of charge, to any person or organization
obtaining a copy of the software and accompanying documentation covered by
this license (the "Software") to use, reproduce, display, distribute,
execute, and transmit the Software, and to prepare derivative works of the
Software, and to permit third-parties to whom the Software is furnished to
do so, all subject to the following:

The copyright notices in the Software and this entire statement, including
the above license grant, this restriction and the following disclaimer,
must be included in all copies of the Software, in whole or in part, and
all derivative works of the Software, unless such copies or derivative
works are solely in the form of machine-executable object code generated by
a source language processor.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT
SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE
FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.

*/
module derelict.util.compat;

version(D_Version2)
{
    mixin("alias const(char)* CCPTR;");
    mixin("alias const(wchar)* CWCPTR;");
    mixin("alias const(dchar)* CDCPTR;");
    mixin("alias const(ubyte)* CUBPTR;");
    mixin("alias const(void)* CVPTR;");
    mixin("alias immutable(char)* ICPTR;");
}
else
{
    alias char* CCPTR;
    alias wchar* CWCPTR;
    alias dchar* CDCPTR;
    alias ubyte* CUBPTR;
    alias void* CVPTR;
    alias char* ICPTR;
}

version(D_Version2) 
{
	public import core.stdc.config : c_long, c_ulong; 
}
else version(Tango)
{
	version (Windows)
	{
		alias int c_long;
		alias uint c_ulong;
	}
	else
	{
		static if((void*).sizeof > (int).sizeof)
		{
			alias long c_long;
			alias ulong c_ulong;
		}
		else
		{
			alias int c_long;
			alias uint c_ulong;
		}
	}
}

version(D_Version2)
{
	version(Posix)
	{
		public import core.sys.posix.sys.types : off_t;
	}
	else
	{
		alias c_long off_t;
	}
}
else
{
	alias c_long off_t;
}

version(Tango)
{
    private
    {
        import tango.stdc.string;
        import tango.stdc.stringz;
        import tango.text.Util;
        import tango.core.Version;
    }

    version (PhobosCompatibility) {}
    else
    {
        alias char[] string;
        alias wchar[] wstring;
        alias dchar[] dstring;
    }
}
else
{
    private
    {
        version(D_Version2)
        {
            import std.conv;
        }
        import std.string;
        import core.stdc.string;
    }
 
}

template gsharedString ()
{
    version (D_Version2)
        const gsharedString = "__gshared: ";

    else
        const gsharedString = "";
}

CCPTR toCString(string str)
{
    return toStringz(str);
}

string toDString(CCPTR cstr)
{
    version(Tango)
    {
        return fromStringz(cstr);
    }
    else
    {
        version(D_Version2)
        {
            mixin("return to!string(cstr);");
        }
        else
        {
            return toString(cstr);
        }
    }
}

int findStr(string str, string match)
{
    version(Tango)
    {
        int i = locatePattern(str, match);
        return (i == str.length) ? -1 : i;
    }
    else
    {
        version(D_Version2)
        {
            mixin("return cast(int)indexOf(str, match);");
        }
        else
        {
            return find(str, match);
        }
    }
}

string[] splitStr(string str, string delim)
{
    return split(str, delim);
}

string stripWhiteSpace(string str)
{
    version(Tango)
    {
        return trim(str);
    }
    else
    {
        return strip(str);
    }
}

