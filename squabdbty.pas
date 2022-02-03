
unit squabdbty;
interface

{
  Automatically converted by H2Pas 1.0.0 from squabdb.h
  The following command line parameters were used:
    squabdb.h
}

{$IFDEF FPC}
{$PACKRECORDS C}
{$ENDIF}


  {---------- headerfile for squabdb.ddl ---------- }
  { alignment is 8  }
  {---------- structures ---------- }
  { size 351  }

  type
    breeds = record
      name : array[0..59] of char;
      category : array[0..10] of char;
      origin : array[0..59] of char;
      imageid : array[0..59] of char;
      description : array[0..159] of char;
    end;

  {---------- record names ---------- }

  const
    BREEDS_TBL = 1000;    
  {---------- field names ---------- }
    NAME_FLD = 1001;    
    CATEGORY_FLD = 1002;    
    ORIGIN_FLD = 1003;    
    IMAGEID_FLD = 1004;    
    DESCRIPTION_FLD = 1005;    
  {---------- key names ---------- }
  {---------- sequence names ---------- }
  {---------- integer constants ---------- }

implementation


end.
