database squabdb{

  data file "pigeon.dat" contains breeds;
  key  file "pigeon.ix1" contains breeds.name;
  
  record breeds{
    char name[60];
    char category[11];
    char origin[60];
    char imageid[60];
    char description[160];
    
    primary key name;
  }
}

  
  