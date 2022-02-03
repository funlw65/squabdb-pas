{----------------------------------------------------------------------------
   * File    : typhoon.h
   * Library : typhoon
   * OS      : UNIX, OS/2, DOS
   * Author  : Thomas B. Pedersen
   *
   * Copyright (c) 1994 Thomas B. Pedersen.  All rights reserved.
   *
   * Permission is hereby granted, without written agreement and without
   * license or royalty fees, to use, copy, modify, and distribute this
   * software and its documentation for any purpose, provided that the above
   * copyright notice and the following two  paragraphs appear (1) in all
   * source copies of this software and (2) in accompanying documentation
   * wherever the programatic interface of this software, or any derivative
   * of it, is described.
   *
   * IN NO EVENT SHALL THOMAS B. PEDERSEN BE LIABLE TO ANY PARTY FOR DIRECT,
   * INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT OF
   * THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF HE HAS BEEN
   * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
   *
   * THOMAS B. PEDERSEN SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING, BUT
   * NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
   * A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS ON AN "AS IS"
   * BASIS, AND THOMAS B. PEDERSEN HAS NO OBLIGATION TO PROVIDE MAINTENANCE,
   * SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
   *
   * Description:
   *   Header file for Typhoon library.
   *
   * $Id: typhoon.h,v 1.4 1999/10/04 04:38:32 kaz Exp $
   *
   *-------------------------------------------------------------------------- }
Unit ty;

Interface

{
  Automatically converted by H2Pas 1.0.0 from ty.h
  The following command line parameters were used:
    ty.h
}
uses ctypes;

{$IFDEF FPC}
{$PACKRECORDS C}
{$ENDIF}

Type 
  DB_ADDR = Record
    recid : cuint32;
    recno : cuint32;
  End;

  //Pbyte  = ^byte;
  // Pchar  = ^char;
  PDB_ADDR  = ^DB_ADDR;

  TProcKeyBuild=Procedure (_para1:Pchar; _para2:cuint32; _para3:cuint32);
  TProcSetErr  =Procedure (_para1:cint32; _para2:cint32);



const
  cDllName = {$IFDEF WINDOWS} 'typhoon.dll' {$IFEND}
             {$IFDEF DARWIN} 'libtyphoon.dylib' {$IFEND}
             {$IFDEF LINUX} 'libtyphoon.so' {$IFEND};

{---------- Status codes -------------------------------------------------- }
Const 
  S_NOCR = -(2);{ No current record            	   	 }
  S_NOCD = -(1);{ No current database					 }
  S_OKAY = 0;{ Operation successful         		 }
  S_NOTFOUND = 1;{ Key not found                		 }
  S_DUPLICATE = 2;{ Duplicate key found 					 }
  S_DELETED = 3;{ Record is deleted					 }
  S_RESTRICT = 4;{ Restrict rule encountered(db_subcode) }
  S_FOREIGN = 5;{ No foreign key (db_subcode)			 }
  S_LOCKED = 8;{ Record is locked						 }
  S_UNLOCKED = 9;{ Record is unlocked					 }
  S_VERSION = 10;{ B-tree or data file has wrong version }
  S_INVPARM = 11;{ Invalid parameter					 }
  S_NOMEM = 200;{ Out of memory						 }
  S_NOTAVAIL = 201;{ Database not available				 }
  S_IOFATAL = 202;{ Fatal I/O operation					 }
  S_FATAL = 203;{ Fatal error - recover				 }
  S_MAXCLIENTS = 500;{ Too many clients						 }
  S_NOSERVER = 501;{ No server is installed				 }
  {---------- User errors --------------------------------------------------- }
  S_INVDB = 1000;{ Invalid database						 }
  S_INVREC = 1001;{ Invalid record						 }
  S_INVFLD = 1002;{ Invalid field name					 }
  S_NOTKEY = 1003;{ Field is not a key					 }
  S_RECSIZE = 1004;{ Variable length record has invalid sz }
  S_BADTYPE = 1005;{ Bad parameter type					 }
  S_INVKEY = 1006;{ Invalid key							 }
  S_INVADDR = 1007;{ Invalid database address (rec number) }
  S_INVSEQ = 1008;{ Invalid sequence id					 }
  {---------- Lock types ---------------------------------------------------- }
  LOCK_TEST = 1;{ Test if a record is locked			 }
  LOCK_UPDATE = 2;{ Lock a record for update				 }


Var 
  curr_rec : cuint32;  cvar;  external;
  db_status : cint32;  cvar;  external;
  { See S_... constants				 }
  db_subcode : cint32;  cvar;  external;

{---------- Function prototypes ------------------------------------------- }

Function d_block: cint16;cdecl;external cDllName;
Function d_unblock: cint16;cdecl;external cDllName;
Function d_setfiles(_para1:cint32): cint16;cdecl;external cDllName;
//Function d_keybuild(_para1:Procedure (_para1:Pchar; _para2:cuint32; _para3:cuint32)): cint16;cdecl;external cDllName;
Function d_keybuild(_para1:TProcKeyBuild): cint16;cdecl;external cDllName;
Function d_open(_para1:Pchar; _para2:Pchar): cint16;cdecl;external cDllName;
Function d_close: cint16;cdecl;external cDllName;
Function d_destroy(_para1:Pchar): cint16;cdecl;external cDllName;
Function d_keyfind(_para1:cuint32; _para2:pointer): cint16;cdecl;external cDllName;
Function d_keyfrst(_para1:cuint32): cint16;cdecl;external cDllName;
Function d_keylast(_para1:cuint32): cint16;cdecl;external cDllName;
Function d_keynext(_para1:cuint32): cint16;cdecl;external cDllName;
Function d_keyprev(_para1:cuint32): cint16;cdecl;external cDllName;
Function d_keyread(_para1:pointer): cint16;cdecl;external cDllName;
Function d_fillnew(_para1:cuint32; _para2:pointer): cint16;cdecl;external cDllName;
Function d_keystore(_para1:cuint32): cint16;cdecl;external cDllName;
Function d_recwrite(_para1:pointer): cint16;cdecl;external cDllName;
Function d_recread(_para1:pointer): cint16;cdecl;external cDllName;
Function d_crread(_para1:cuint32; _para2:pointer): cint16;cdecl;external cDllName;
Function d_delete: cint16;cdecl;external cDllName;
Function d_recfrst(_para1:cuint32): cint16;cdecl;external cDllName;
Function d_reclast(_para1:cuint32): cint16;cdecl;external cDllName;
Function d_recnext(_para1:cuint32): cint16;cdecl;external cDllName;
Function d_recprev(_para1:cuint32): cint16;cdecl;external cDllName;
Function d_crget(_para1:PDB_ADDR): cint16;cdecl;external cDllName;
Function d_crset(_para1:PDB_ADDR): cint16;cdecl;external cDllName;
Function d_dbget(_para1:Plongint): cint16;cdecl;external cDllName;
Function d_dbset(_para1:cint32): cint16;cdecl;external cDllName;
Function d_records(_para1:cuint32; _para2:pcuint32): cint16;cdecl;external cDllName;
Function d_keys(_para1:cuint32): cint16;cdecl;external cDllName;
Function d_dbdpath(_para1:Pchar): cint16;cdecl;external cDllName;
Function d_dbfpath(_para1:Pchar): cint16;cdecl;external cDllName;
Function d_reclock(_para1:PDB_ADDR; _para2:cint32): cint16;cdecl;external cDllName;
Function d_recunlock(_para1:PDB_ADDR): cint16;cdecl;external cDllName;
Function d_getsequence(_para1:cuint32; _para2:pcuint32): cint16;cdecl;external cDllName;
Function d_replicationlog(_para1:cint32): cint16;cdecl;external cDllName;
Function d_addsite(_para1:cuint32): cint16;cdecl;external cDllName;
Function d_delsite(_para1:cuint32): cint16;cdecl;external cDllName;
Function d_deltable(_para1:cuint32; _para2:cuint32): cint16;cdecl;external cDllName;
Function d_getkeysize(_para1:cuint32; _para2:pcuint32): cint16;cdecl;external cDllName;
Function d_getrecsize(_para1:cuint32; _para2:pcuint32): cint16;cdecl;external cDllName;
Function d_getfieldtype(_para1:cuint32; _para2:pcuint32): cint16;cdecl;external cDllName;
Function ty_ustrcmp(_para1:Pbyte; _para2:Pbyte): cint16;cdecl;external cDllName;
Function d_getkeyid(_para1:cuint32; _para2:pcuint32): cint16;cdecl;external cDllName;
Function d_getforeignkeyid(_para1:cuint32; _para2:cuint32; _para3:pcuint32): cint16;cdecl;external cDllName;
Function d_makekey(_para1:cuint32; _para2:pointer; _para3:pointer): cint16;cdecl;external cDllName;
//Function d_seterrfn(_para1:Procedure (_para1:cint32; _para2:longint)): cint16;cdecl;external cDllName;
Function d_seterrfn(_para1:TProcSetErr): cint16;cdecl;external cDllName;

//{$endif}
  { end-of-file  }

Implementation

End.
