program squabdb;
{
  A list of Performing Pigeons from Europe.
  * This is a demonstration for typhoon database and for
  * raylib 4.0 + raygui 3.0 graphic libraries.
  * Copyright 2022 by Vasile Guţă-Ciucur
  * Released under BSD license
}

{$mode objfpc}{$H+}
uses
//heaptrc,
sysutils,
ty,
squabdbty,
{uncomment if necessary}
//rmath,
//rlgl,
raylib,
raygui;

const
  screenWidth = 1366;   // Laptop screen
  screenHeight = 706;
  // Panels' position on the screen
  pSplash_posX = 332;
  pSplash_posY = 136;
  pMain_posX = 213;
  pMain_posY = 40;
  // Define the Application's colors
  clTeal : TColor = (r: 97; g: 190; b: 221; a: 255);
  clGray : TColor = (r: 206; g: 206; b: 206; a: 255);
  clBlueGray : TColor  = (r: 231; g: 231; b: 239; a: 255);
  clGreen : TColor = (r: 180; g: 192; b: 69; a: 255);
  clLCD: TColor = (r: 50; g: 50; b: 50; a: 255);
  clDarkBlue : TColor = (r: 45; g: 43; b: 56; a: 255); 
  cllightBlue : TColor = (r: 51; g: 102; b: 152; a: 255); //#336698 
  clAlmostBlack : TColor = (r: 33; g: 33; b: 33; a: 255);
  clCreme : TColor = (r: 223; g: 196; b: 125; a: 255);
  clPhotoFrame :TColor = (r: 45; g: 57; b: 95; a: 255);
  clBrick : TColor = (r: 206; g: 72; b: 0; a: 255);
  clGrass : TColor = (r: 98; g: 187; b: 45; a: 255);
  //clRed


var
  currentScreen, originated : integer;
  
  // the main colors of the application
  clBackground,
  clPanel,
  clLabels,
  clLetter,
  clFrames,
  clPhoto : TColor;
  
  
  bufferIcon : TImage;
  bufferTex, bufferTex2, iNoImage,
  //speedbutton images
  sbFirst,
  sbPrev,
  sbNext,
  sbLast,
  sbFind,
  sbAdd,
  sbMod,
  sbDel,
  sbInfo,
  sbExit,
  //
  sbFirst_gray,
  sbPrev_gray,
  sbNext_gray,
  sbLast_gray,
  sbFind_gray,
  sbAdd_gray,
  sbMod_gray,
  sbDel_gray,
  //
  iPigeon_Welcome,
  iPigeon_Bye,
  iGrass2b, 
  iGrass1a, 
  iSlime1,
  iSlime2,
  iAbout,
  
  iFirefly1,
  iFirefly2,
  iLadybug,
  iFindLarge, 
  iAddLarge,
  iModLarge
  : TTexture2D;


  // status buttons
  bSplashClose_click,
  bQuitYes_click,
  bQuitNo_click,  
  bErrorNextKey_click,
  bErrorFindKey_click,
  bDelYes_click,
  bDelNo_click,
  bFindKey_click,
  bResultDel_click,
  bResultMod_click,
  bResultClose_click,
  bResultDelYes_click,
  bResultDelNo_click,
  //
  bAddSave_click,
  bAddCancel_click,
  bErrorAddKey_click,
  //
  bModSave_click,
  bModCancel_click,
  //
  //speedbutton enabled/disabled
  sbFirst_active,
  sbPrev_active,
  sbNext_active,
  sbLast_active,
  sbFind_active,
  sbAdd_active,
  sbMod_active,
  sbDel_active
  : boolean;
  iSearchEdit: boolean = false;
  iBreedEdit: boolean = false;
  iCategoryEdit: boolean = false;
  iOriginEdit: boolean = false;
  iImageidEdit: boolean = false;
  iDesc1Edit: boolean = false;
  iDesc2Edit: boolean = false;
  //
  exitWindow : boolean;
  // detecting the speedbutton collision with mouse pointer at mouseclick
  rec_sbFirst,
  rec_sbPrev,
  rec_sbNext,
  rec_sbLast,
  rec_sbFind,
  rec_sbAdd,
  rec_sbMod,
  rec_sbDel,
  rec_sbInfo,
  rec_sbExit,
  // combobox
  rec_cbTheme,
  rec_photoFrame,
  rec_common
  : TRectangle; 

  // combobox_index
  cbTheme_idx : longint;
  cbTheme_edit : boolean;

  mousePosition, commonPos, commonPos2 : TVector2;
  fontTitle, fontLetter, fontLabel, fontSButton, fontDesc : TFont;
  fontNil : PLongInt;
  
  stp : integer;
  
  // pigeon database record structure
  project_subfolder,
  breed,breed_buff,
  cat,cat_buff,
  orig,orig_buff,
  desc,desc_buff,
  imgid,imgid_buff,
  desc1,desc1_buff,desc2, desc2_buff :string;
  //
  brd : breeds;
  cr_rec : DB_ADDR;
  //
  squabdb_empty, cycle_common : boolean;
  //
  i, ln, add_err, mod_err : byte;

  err_msg,
  image_path:string;
  //
  eText : array [0..59] of char = '';
  //
  eBreed    : array [0..59] of char = '';
  eCategory : array [0..10] of char = '';
  eOrigin   : array [0..59] of char = '';
  eImageid  : array [0..59] of char = '';
  eDesc1    : array [0..79] of char = '';
  eDesc2    : array [0..79] of char = '';
  eDescription    : array [0..159] of char = '';
  //
  eBreed_buff    : array [0..59] of char = '';
  eCategory_buff : array [0..10] of char = '';
  eOrigin_buff   : array [0..59] of char = '';
  eImageid_buff  : array [0..59] of char = '';
  eDesc1_buff    : array [0..79] of char = '';
  eDesc2_buff    : array [0..79] of char = '';
  eDescription_buff    : array [0..159] of char = '';
  //

procedure clear_mod_fields;
begin
  eBreed_buff    := '';
  eCategory_buff := '';
  eOrigin_buff   := '';
  eImageid_buff  := '';
  eDesc1_buff    := '';
  eDesc2_buff    := '';
end;

procedure clear_add_fields;
begin
  eBreed    := '';
  eCategory := '';
  eOrigin   := '';
  eImageid  := '';
  eDesc1    := '';
  eDesc2    := '';
end;

procedure clear_buffer_fields;
begin
  breed_buff := '';
  cat_buff   := '';
  orig_buff  := '';
  desc_buff  := '';
  imgid_buff := '';
  desc1_buff := '';
  desc2_buff := '';
end;  

procedure clear_fields;
begin
  breed := '';
  cat   := '';
  orig  := '';
  desc  := '';
  imgid := '';
  desc1 := '';
  desc2 := '';
end;  
  

procedure load_imageid(var im: string; var bTex:TTexture2D);
begin
  UnloadTexture(bTex);
  if im <> '' then begin 
    image_path := trim(project_subfolder + im); 
    if(FileExists(@image_path[1])) then begin
      bufferIcon := LoadImage(@image_path[1]);
      bTex := LoadTextureFromImage(bufferIcon);
      UnloadImage(bufferIcon);
    end
    else begin
      bufferIcon := LoadImage('pictures/noimage.png');
      bTex := LoadTextureFromImage(bufferIcon);
      UnloadImage(bufferIcon);  
    end;  
  end
  else begin
    bufferIcon := LoadImage('pictures/noimage.png');
    bTex := LoadTextureFromImage(bufferIcon);
    UnloadImage(bufferIcon);  
  end;  
end;

procedure prepare_fields;
begin
  d_crget(@cr_rec);
  eCategory := cat; 
  eOrigin := orig;
  eImageid := imgid;
  ln := Length(desc);
  if (ln <= 80) then begin
    eDesc1 := desc;
    eDesc2 := '';
  end 
  else begin
    eDesc1 := copy(desc, 1, 80);
    eDesc2 := copy(desc, 81, ln-80);
  end;
end;

begin
  //--------------------------------------------------------------------
  // Database stuff
  //--------------------------------------------------------------------
  clear_fields;
  clear_buffer_fields;
  clear_mod_fields;
  clear_add_fields;
  project_subfolder := 'pictures/';
  //
  {$I-}
  if(not DirectoryExists('data')) then
    MkDir('data');
  {$I+}
  //
  d_dbfpath('data');  
  if( d_open('squabdb', 'x') = S_OKAY ) then begin 
    if(d_keyfrst(NAME_FLD) = S_OKAY) then begin
      d_recread(@brd);
      breed := brd.name;
      cat := brd.category;
      orig := brd.origin;
      imgid := brd.imageid;
      desc := brd.description;
      squabdb_empty  := false;
      sbFirst_active := false;
      sbPrev_active  := false;
      sbNext_active  := true;
      sbLast_active  := true;
      sbFind_active  := true;
      sbAdd_active   := true;
      sbMod_active   := true;
      sbDel_active   := true;
    end
    else begin
      squabdb_empty := true;
      clear_fields;    
    end;   
    // -------------------------------------------------------------------
    // Raylib Initialization
    // -------------------------------------------------------------------
    InitWindow(screenWidth, screenHeight, 'SquabDB - Pigeon Database');
    SetTargetFPS(16);// Set our "game" to run at 17 frames-per-second
    GuiSetStyle(DEFAULT, TEXT_SIZE, 16);
    GuiSetState(GUI_STATE_NORMAL);
    exitWindow := false;
    SetExitKey(0);
  
    fontNil := Nil;
    fontTitle   := LoadFontEx('style/Accanthis.otf', 56, fontNil, 0);
    fontLetter  := LoadFontEx('style/Accanthis.otf', 24, fontNil, 0);
    fontLabel   := LoadFontEx('style/FreeSans.ttf', 20, fontNil, 0);
    fontSButton := LoadFontEx('style/Mecha.ttf', 14, fontNil, 0);
    fontDesc    := LoadFontEx('style/Mecha.ttf', 16, fontNil, 0);
      
    bufferIcon := LoadImage('pictures/noimage.png');
    iNoImage   := LoadTextureFromImage(bufferIcon);
    bufferTex  := LoadTextureFromImage(bufferIcon);
    bufferTex2 := LoadTextureFromImage(bufferIcon);
    UnloadImage(bufferIcon);
    load_imageid(imgid, bufferTex);  

    // Splash
    bufferIcon := LoadImage('img/Pigeon.png');
    iPigeon_Welcome := LoadTextureFromImage(bufferIcon);
    UnloadImage(bufferIcon);
    // Exit
    bufferIcon := LoadImage('img/Flying_Pigeon.png');
    iPigeon_Bye := LoadTextureFromImage(bufferIcon);
    UnloadImage(bufferIcon);
    bufferIcon := LoadImage('img/slime1.png');
    iSlime1 := LoadTextureFromImage(bufferIcon);
    UnloadImage(bufferIcon);  
    bufferIcon := LoadImage('img/slime2.png');
    iSlime2 := LoadTextureFromImage(bufferIcon);
    UnloadImage(bufferIcon);  
    // About
    bufferIcon := LoadImage('img/about.png');
    iAbout := LoadTextureFromImage(bufferIcon);
    UnloadImage(bufferIcon);  
    bufferIcon := LoadImage('img/grass1a.png');
    iGrass1a := LoadTextureFromImage(bufferIcon);
    UnloadImage(bufferIcon);
    bufferIcon := LoadImage('img/grass2b.png');
    iGrass2b := LoadTextureFromImage(bufferIcon);
    UnloadImage(bufferIcon);
    //
    bufferIcon := LoadImage('img/firefly1.png');
    iFirefly1 := LoadTextureFromImage(bufferIcon);
    UnloadImage(bufferIcon);
    bufferIcon := LoadImage('img/firefly2.png');
    iFirefly2 := LoadTextureFromImage(bufferIcon);
    UnloadImage(bufferIcon);
    bufferIcon := LoadImage('img/ladybug.png');
    iLadybug := LoadTextureFromImage(bufferIcon);
    UnloadImage(bufferIcon);
    // 
    bufferIcon := LoadImage('img/general/128/iLfind.png');
    iFindLarge := LoadTextureFromImage(bufferIcon);
    UnloadImage(bufferIcon);
    bufferIcon := LoadImage('img/general/128/iLmod.png');// downgraded to 64x64, aestetic reasons
    iModLarge := LoadTextureFromImage(bufferIcon);
    UnloadImage(bufferIcon);
    bufferIcon := LoadImage('img/general/iLadd.png');// downgraded to 64x64
    iAddLarge := LoadTextureFromImage(bufferIcon);
    UnloadImage(bufferIcon);

    // load the icons of emulated speedbuttons
    bufferIcon := LoadImage('img/general/first.png');
    sbFirst := LoadTextureFromImage(bufferIcon);
    UnloadImage(bufferIcon);
    //
    bufferIcon := LoadImage('img/general/prev.png');
    sbPrev := LoadTextureFromImage(bufferIcon);
    UnloadImage(bufferIcon);
    //
    bufferIcon := LoadImage('img/general/next.png');
    sbNext := LoadTextureFromImage(bufferIcon);
    UnloadImage(bufferIcon);
    //
    bufferIcon := LoadImage('img/general/last.png');
    sbLast := LoadTextureFromImage(bufferIcon);
    UnloadImage(bufferIcon);
    //
    bufferIcon := LoadImage('img/general/find.png');
    sbFind := LoadTextureFromImage(bufferIcon);
    UnloadImage(bufferIcon);
    //
    bufferIcon := LoadImage('img/general/add.png');
    sbAdd := LoadTextureFromImage(bufferIcon);
    UnloadImage(bufferIcon);
    //
    bufferIcon := LoadImage('img/general/mod.png');
    sbMod := LoadTextureFromImage(bufferIcon);
    UnloadImage(bufferIcon);
    //
    bufferIcon := LoadImage('img/general/del.png');
    sbDel := LoadTextureFromImage(bufferIcon);
    UnloadImage(bufferIcon);
    //
    bufferIcon := LoadImage('img/general/info.png');
    sbInfo := LoadTextureFromImage(bufferIcon);
    UnloadImage(bufferIcon);
    //
    bufferIcon := LoadImage('img/general/quit.png');
    sbExit := LoadTextureFromImage(bufferIcon);
    UnloadImage(bufferIcon);
    // _gray
    bufferIcon := LoadImage('img/general/first_gray.png');
    sbFirst_gray := LoadTextureFromImage(bufferIcon);
    UnloadImage(bufferIcon);
    //
    bufferIcon := LoadImage('img/general/prev_gray.png');
    sbPrev_gray := LoadTextureFromImage(bufferIcon);
    UnloadImage(bufferIcon);
    //
    bufferIcon := LoadImage('img/general/next_gray.png');
    sbNext_gray := LoadTextureFromImage(bufferIcon);
    UnloadImage(bufferIcon);
    //
    bufferIcon := LoadImage('img/general/last_gray.png');
    sbLast_gray := LoadTextureFromImage(bufferIcon);
    UnloadImage(bufferIcon);
    //
    bufferIcon := LoadImage('img/general/find_gray.png');
    sbFind_gray := LoadTextureFromImage(bufferIcon);
    UnloadImage(bufferIcon);
    //
    bufferIcon := LoadImage('img/general/add_gray.png');
    sbAdd_gray := LoadTextureFromImage(bufferIcon);
    UnloadImage(bufferIcon);
    //
    bufferIcon := LoadImage('img/general/mod_gray.png');
    sbMod_gray := LoadTextureFromImage(bufferIcon);
    UnloadImage(bufferIcon);
    //
    bufferIcon := LoadImage('img/general/del_gray.png');
    sbDel_gray := LoadTextureFromImage(bufferIcon);
    UnloadImage(bufferIcon);
    
    
    // simulating clicks
    bSplashClose_click := false;
    bQuitYes_click := false;
    bQuitNo_click := false;
    bErrorNextKey_click := false;


    // rectangle areas of the simulated speedbuttons...
  
    rec_sbFirst.x := 252 - 48;
    rec_sbFirst.y := 72;
    rec_sbFirst.width := 32;
    rec_sbFirst.height := 32;
  
    rec_sbPrev.x := 252;
    rec_sbPrev.y := 72;
    rec_sbPrev.width := 32;
    rec_sbPrev.height := 32;

    rec_sbNext.x := 300;
    rec_sbNext.y := 72;
    rec_sbNext.width := 32;
    rec_sbNext.height := 32;
  
    rec_sbLast.x := 348;
    rec_sbLast.y := 72;
    rec_sbLast.width := 32;
    rec_sbLast.height := 32;

    rec_sbFind.x := 348 + 48;
    rec_sbFind.y := 72;
    rec_sbFind.width := 32;
    rec_sbFind.height := 32;
  
    rec_sbAdd.x := 396 + 48;
    rec_sbAdd.y := 72;
    rec_sbAdd.width := 32;
    rec_sbAdd.height := 32;
  
    rec_sbMod.x := 444 + 48;
    rec_sbMod.y := 72;
    rec_sbMod.width := 32;
    rec_sbMod.height := 32;
  
    rec_sbDel.x := 492 + 48;
    rec_sbDel.y := 72;
    rec_sbDel.width := 32;
    rec_sbDel.height := 32;
  
    rec_sbInfo.x := 540 + 48;
    rec_sbInfo.y := 72;
    rec_sbInfo.width := 32;
    rec_sbInfo.height := 32;
  
    rec_sbExit.x := 588 + 48; 
    rec_sbExit.y := 72; 
    rec_sbExit.width := 32; 
    rec_sbExit.height := 32; 
  
    // combobox rectangle
    rec_cbTheme.x := pSplash_posX + 150; 
    rec_cbTheme.y := pSplash_posY + 398; 
    rec_cbTheme.width := 130; 
    rec_cbTheme.height := 32;
    //
    rec_photoFrame.x := 677 + 48; 
    rec_photoFrame.y := 72; 
    rec_photoFrame.width := 400; 
    rec_photoFrame.height := 400; 


    // combobox_index
    cbTheme_idx := 0;
    cbTheme_edit := false;
     
    currentScreen := -1;
  
    GuiLoadStyle('style/squabdb_dark.rgs');
    clBackground := clDarkBlue;
    clPanel := clAlmostBlack;
    clLabels := LIGHTGRAY;
    clLetter := WHITE;
    clFrames := LIGHTGRAY;
    clPhoto := DARKGRAY;
  
    {GuiLoadStyle('style/squabdb_light.rgs');
    clBackground := clLightBlue;
    clPanel := clGray;
    clLabels := DARKGRAY;
    clLetter := BLACK;
    clFrames := GRAY;
    clPhoto := clPhotoFrame;
    }
  
    //--------------------------------------------------------------------
    // Main game loop
    while not exitWindow do begin
      // Update
      //----------------------------------------------------------------
      mousePosition.x := GetMouseX;
      mousePosition.y := GetMouseY;

      //----------------------------------------------------------------
      // Draw
      //----------------------------------------------------------------
      BeginDrawing();
// =====================================================================
// SPLASH SCREEN
// =====================================================================
      if currentScreen = -1 then begin
        // draw splah            
        ClearBackground(clBackground);
        DrawRectangle(pSplash_posX,pSplash_posY,696,664-204,clPanel);
        DrawTexture(iPigeon_Welcome, 200,100, WHITE);
        commonPos.x := single(pSplash_posX + 280);
        commonPos.y := single(pSplash_posY + 50);
        DrawTextEx(fontTitle, 'Welcome!', commonPos, 56, 2, clLabels);
        //
        commonPos.x := single(pSplash_posX + 180);
        commonPos.y := single(pSplash_posY + 150);
        DrawTextEx(fontLetter, 'SquabDB is a little Pigeon database, intended as', commonPos, 24, 2, clLabels);
        commonPos.x := single(pSplash_posX + 180);
        commonPos.y := single(pSplash_posY + 174);
        DrawTextEx(fontLetter, 'demonstrator for typhoon database engine, raylib', commonPos, 24, 2, clLabels);
        commonPos.x := single(pSplash_posX + 180);
        commonPos.y := single(pSplash_posY + 198);
        DrawTextEx(fontLetter, 'and raygui graphical libraries. ', commonPos, 24, 2, clLabels);
        commonPos.x := single(pSplash_posX + 180);
        commonPos.y := single(pSplash_posY + 222);
        DrawTextEx(fontLetter, 'Pigeon cartoons are licensed to: ', commonPos, 24, 2, clLabels);
        commonPos.x := single(pSplash_posX + 180);
        commonPos.y := single(pSplash_posY + 246);
        DrawTextEx(fontLetter, '   - David StClair (Wildchief)', commonPos, 24, 2, clLabels);
        commonPos.x := single(pSplash_posX + 180);
        commonPos.y := single(pSplash_posY + 270);
        DrawTextEx(fontLetter, '   - Dmitry Moiseenko', commonPos, 24, 2, clLabels);
        //
        commonPos.x := single(pSplash_posX + 180);
        commonPos.y := single(pSplash_posY + 314);
        DrawTextEx(fontLetter, 'Copyright 2022 by Vasile Guta-Ciucur.', commonPos, 24, 2, clLabels);
        commonPos.x := single(pSplash_posX + 180);
        commonPos.y := single(pSplash_posY + 338);
        DrawTextEx(fontLetter, 'Application is BSD licensed.', commonPos, 24, 2, clLabels);
        //
        commonPos.x := single(pSplash_posX + 80);
        commonPos.y := single(pSplash_posY + 406);
        DrawTextEx(fontLabel, 'Theme:', commonPos, 20, 1, clLabels);
        //
        if GuiDropdownBox(rec_cbTheme,'DARK;LIGHT', @cbTheme_idx, cbTheme_edit) then
          cbTheme_edit := not cbTheme_edit;
        bSplashClose_click := GuiButton(RectangleCreate(pSplash_posX + 530, pSplash_posY + 398, 88, 32), 'Close');
        if bSplashClose_click then begin 
          bSplashClose_click := false;
          currentScreen := 0;            
          if cbTheme_idx = 1 then begin 
            GuiLoadStyle('style/squabdb_light.rgs');
            clBackground := clLightBlue;
            clPanel := clBlueGray;
            clLabels := DARKGRAY;
            clLetter := BLACK;
            clFrames := GRAY;
            clPhoto := clPhotoFrame;
          end;
        end;  
      end; //end page/screen
// =====================================================================
// MAIN PANEL !!!
// =====================================================================
      if currentScreen = 0 then begin
        originated := 0; 
        if squabdb_empty then begin
          //if database is empty
          sbFirst_active := false;
          sbPrev_active := false;
          sbNext_active := false;
          sbLast_active := false;
          sbFind_active := false;
          sbAdd_active := true;
          sbMod_active := false;
          sbDel_active := false;
        end;
        //exitWindow := WindowShouldClose;
        ClearBackground(clBackground);
        DrawTexture(iGrass1a, pMain_posX-82-48, pMain_posY + 425, WHITE);
        DrawRectangle(pMain_posX-48,pMain_posY,896+96,600,clPanel); // MAIN PANEL
        DrawTexture(iGrass2b, pMain_posX+802+48, pMain_posY + 423, WHITE);
        //
        DrawRectangleRoundedLines(rec_sbFirst, 0.2, 4, 2, DARKGRAY);
        DrawRectangleRoundedLines(rec_sbPrev, 0.2, 4, 2, DARKGRAY);
        DrawRectangleRoundedLines(rec_sbNext, 0.2, 4, 2, DARKGRAY);
        DrawRectangleRoundedLines(rec_sbLast, 0.2, 4, 2, DARKGRAY);
        DrawRectangleRoundedLines(rec_sbFind, 0.2, 4, 2, DARKGRAY);
        DrawRectangleRoundedLines(rec_sbAdd, 0.2, 4, 2, DARKGRAY);
        DrawRectangleRoundedLines(rec_sbMod, 0.2, 4, 2, DARKGRAY);
        DrawRectangleRoundedLines(rec_sbDel, 0.2, 4, 2, DARKGRAY);
        DrawRectangleRoundedLines(rec_sbInfo, 0.2, 4, 2, DARKGRAY);
        DrawRectangleRoundedLines(rec_sbExit, 0.2, 4, 2, DARKGRAY);
        //
        // highlight the active speedbuttons under the mouse.
        if CheckCollisionPointRec(mousePosition, rec_sbFirst) then
          if sbFirst_active then
            DrawRectangleRoundedLines(rec_sbFirst, 0.2, 4, 2, ORANGE);
        if CheckCollisionPointRec(mousePosition, rec_sbPrev) then
          if sbPrev_active then
            DrawRectangleRoundedLines(rec_sbPrev, 0.2, 4, 2, ORANGE);
        if CheckCollisionPointRec(mousePosition, rec_sbNext) then
          if sbNext_active then
            DrawRectangleRoundedLines(rec_sbNext, 0.2, 4, 2, ORANGE);
        if CheckCollisionPointRec(mousePosition, rec_sbLast) then
          if sbLast_active then
            DrawRectangleRoundedLines(rec_sbLast, 0.2, 4, 2, ORANGE);
        if CheckCollisionPointRec(mousePosition, rec_sbFind) then
          if sbFind_active then
            DrawRectangleRoundedLines(rec_sbFind, 0.2, 4, 2, ORANGE);
        if CheckCollisionPointRec(mousePosition, rec_sbAdd) then
          if sbAdd_active then
            DrawRectangleRoundedLines(rec_sbAdd, 0.2, 4, 2, ORANGE);
        if CheckCollisionPointRec(mousePosition, rec_sbMod) then
          if sbMod_active then
            DrawRectangleRoundedLines(rec_sbMod, 0.2, 4, 2, ORANGE);
        if CheckCollisionPointRec(mousePosition, rec_sbDel) then
          if sbDel_active then
            DrawRectangleRoundedLines(rec_sbDel, 0.2, 4, 2, ORANGE);
        if CheckCollisionPointRec(mousePosition, rec_sbInfo) then
          DrawRectangleRoundedLines(rec_sbInfo, 0.2, 4, 2, ORANGE);
        if CheckCollisionPointRec(mousePosition, rec_sbExit) then
          DrawRectangleRoundedLines(rec_sbExit, 0.2, 4, 2, ORANGE);
            
        // draw the pictograms inside speedbutton
        if sbFirst_active then
          DrawTexture(sbFirst,round(rec_sbFirst.x),72,WHITE)
        else
          DrawTexture(sbFirst_gray,round(rec_sbFirst.x),72,WHITE);
        if sbPrev_active then
          DrawTexture(sbPrev,round(rec_sbPrev.x),72,WHITE)
        else
          DrawTexture(sbPrev_gray,round(rec_sbPrev.x),72,WHITE);
        if sbNext_active then
          DrawTexture(sbNext,round(rec_sbNext.x),72,WHITE)
        else
          DrawTexture(sbNext_gray,round(rec_sbNext.x),72,WHITE);
        if sbLast_active then
          DrawTexture(sbLast,round(rec_sbLast.x),72,WHITE)
        else
          DrawTexture(sbLast_gray,round(rec_sbLast.x),72,WHITE);
        if sbFind_active then
          DrawTexture(sbFind,round(rec_sbFind.x),72,WHITE)
        else
          DrawTexture(sbFind_gray,round(rec_sbFind.x),72,WHITE);
        if sbAdd_active then
          DrawTexture(sbAdd,round(rec_sbAdd.x),72,WHITE)
        else
          DrawTexture(sbAdd_gray,round(rec_sbAdd.x),72,WHITE);
        if sbMod_active then
          DrawTexture(sbMod,round(rec_sbMod.x),72,WHITE)
        else
          DrawTexture(sbMod_gray,round(rec_sbMod.x),72,WHITE);
        if sbDel_active then
          DrawTexture(sbDel,round(rec_sbDel.x),72,WHITE)
        else
          DrawTexture(sbDel_gray,round(rec_sbDel.x),72,WHITE);
        
        DrawTexture(sbInfo, round(rec_sbInfo.x), 72, WHITE);
        DrawTexture(sbExit, round(rec_sbExit.x), 72, WHITE);
        //
        commonPos.x := rec_sbFirst.x;
        commonPos.y := single(108);
        DrawTextEx(FontSButton, 'First', commonPos, 14, 1, clLabels);
        //
        commonPos.x := rec_sbPrev.x;
        commonPos.y := single(108);
        DrawTextEx(FontSButton, 'Prev', commonPos, 14, 1, clLabels);
        //
        commonPos.x := rec_sbNext.x;
        commonPos.y := single(108);
        DrawTextEx(FontSButton, 'Next', commonPos, 14, 1, clLabels);
        //
        commonPos.x := rec_sbLast.x;
        commonPos.y := single(108);
        DrawTextEx(FontSButton, 'Last', commonPos, 14, 1, clLabels);
        //
        commonPos.x := rec_sbFind.x;
        commonPos.y := single(108);
        DrawTextEx(FontSButton, 'Find', commonPos, 14, 1, clLabels);
        //
        commonPos.x := rec_sbAdd.x;
        commonPos.y := single(108);
        DrawTextEx(FontSButton, 'Add', commonPos, 14, 1, clLabels);
        //
        commonPos.x := rec_sbMod.x;
        commonPos.y := single(108);
        DrawTextEx(FontSButton, 'Mod', commonPos, 14, 1, clLabels);
        //
        commonPos.x := rec_sbDel.x;
        commonPos.y := single(108);
        DrawTextEx(FontSButton, 'Del', commonPos, 14, 1, clLabels);
        //
        commonPos.x := rec_sbInfo.x;
        commonPos.y := single(108);
        DrawTextEx(FontSButton, 'About', commonPos, 14, 1, clLabels);
        //
        commonPos.x := rec_sbExit.x;
        commonPos.y := single(108);
        DrawTextEx(FontSButton, 'Quit', commonPos, 14, 1, clLabels);
        //
        // labels and fields
        commonPos.x := 252-48;
        commonPos.y := 181;
        DrawTextEx(fontLabel, 'BREED NAME:', commonPos, 20, 1, clLabels);
        commonPos.x := 270-48;
        commonPos.y := 215;
        if breed = '' then
          DrawTextEx(fontLetter, '...', commonPos, 24, 1, clLabels)
        else
          DrawTextEx(fontLetter, @breed[1], commonPos, 24, 1, clLabels);
        commonPos.x := 252-48;
        commonPos.y := 261;
        DrawTextEx(fontLabel, 'CATEGORY:', commonPos, 20, 1, clLabels);
        commonPos.x := 270-48;
        commonPos.y := 295;
        if cat = '' then
          DrawTextEx(fontLetter, '...', commonPos, 24, 1, clLabels)
        else
          DrawTextEx(fontLetter, @cat[1], commonPos, 24, 1, clLabels);
        commonPos.x := 252-48;
        commonPos.y := 341;
        DrawTextEx(fontLabel, 'ORIGIN:', commonPos, 20, 1, clLabels);
        commonPos.x := 270-48;
        commonPos.y := 375;
        if orig = '' then
          DrawTextEx(fontLetter, '...', commonPos, 24, 1, clLabels)
        else
          DrawTextEx(fontLetter, @orig[1], commonPos, 24, 1, clLabels);
        commonPos.x := 252-48;
        commonPos.y := 506;
        DrawTextEx(fontLabel, 'DESCRIPTION:', commonPos, 20, 1, clLabels);
        commonPos.x := 270-48;
        commonPos.y := 544;
        DrawTextEx(fontDesc, @desc[1], commonPos, 16, 1, clLabels);
        //
        // draw lines and photo frame
        commonPos.x := single(pMain_posX-48);
        commonPos.y := single(pMain_posY+110);
        commonPos2.x := commonPos.x + 896.0+96;
        commonPos2.y:= commonPos.Y;
        DrawLineEx(commonPos, commonPos2, 4.0, clFrames);
        DrawRectangleRounded(rec_photoFrame,0.1,4,clPhoto);
        commonPos.x := single(rec_photoFrame.x + 176);
        commonPos.y := single(rec_photoFrame.y + 410);
        DrawTextEx(fontSButton, '372 x 372', commonPos, 14, 2, clLetter);
        if imgid = '' then
          DrawTexture(iNoImage,691+48,86,WHITE)
        else  
          DrawTexture(bufferTex,691+48,86,WHITE);

        // MOUSE EVENT!!!
        if IsMouseButtonPressed(MOUSE_BUTTON_LEFT) then begin
          if CheckCollisionPointRec(mousePosition, rec_sbFirst) then
            if sbFirst_active then
              currentScreen := 1;
          if CheckCollisionPointRec(mousePosition, rec_sbPrev) then
            if sbPrev_active then
              currentScreen := 2;
          if CheckCollisionPointRec(mousePosition, rec_sbNext) then
            if sbNext_active then
              currentScreen := 3;
          if CheckCollisionPointRec(mousePosition, rec_sbLast) then
            if sbLast_active then
              currentScreen := 4;
          if CheckCollisionPointRec(mousePosition, rec_sbFind) then
            if sbFind_active then
              currentScreen := 5;
          if CheckCollisionPointRec(mousePosition, rec_sbAdd) then
            if sbAdd_active then begin
              currentScreen := 6;
              clear_add_fields;
              clear_mod_fields;
            end;  
          if CheckCollisionPointRec(mousePosition, rec_sbMod) then
            if sbMod_active then begin
              currentScreen := 7;
              prepare_fields;
            end;  
          if CheckCollisionPointRec(mousePosition, rec_sbDel) then
            if sbDel_active then
              currentScreen := 8;
          if CheckCollisionPointRec(mousePosition, rec_sbInfo) then
            currentScreen := 10;
          if CheckCollisionPointRec(mousePosition, rec_sbExit) then
            currentScreen := 11;
        end;

        // KEY EVENT
        if (IsKeyPressed(KEY_P)) then
          if (sbFirst_active) then
            currentScreen := 1;
        if (IsKeyPressed(KEY_LEFT)) then
          if (sbPrev_active) then
            currentScreen := 2;
        if (IsKeyPressed(KEY_RIGHT)) then
          if (sbNext_active) then
            currentScreen := 3;
        if (IsKeyPressed(KEY_L)) then
          if (sbLast_active) then
            currentScreen := 4;
        if (IsKeyPressed(KEY_F)) then
          if (sbFind_active) then
            currentScreen := 5;
        if (IsKeyPressed(KEY_A)) then
          if (sbAdd_active) then begin
            currentScreen := 6;
            clear_add_fields;
            clear_mod_fields;
          end;
        if (IsKeyPressed(KEY_M)) then
          if (sbMod_active)  then begin
            currentScreen := 7;
            prepare_fields;
          end;
        if (IsKeyPressed(KEY_D)) then
          if (sbDel_active) then
            currentScreen := 8;
        if (IsKeyPressed(KEY_I)) then
          currentScreen := 10;
        if (IsKeyPressed(KEY_X)) then
          currentScreen := 11;

        //==================== GUI ASSISTANT =========================
        // live ui design :) - assistive elements!!! - really life saver - otherwise, you have to use godot to design the UI  
        // - used to find out the coordinates for speedbuttons,
        //   moving the mouse at the desired location and reading 
        //   the coordinates (dragging along a 32x32 rectangle that
        //    simulated the speedbutton then used also for other elements)
        //
        //DrawText('x = ', 0,0,16,WHITE);
        //DrawText('y = ', 0,20,16,WHITE);
        //DrawText(PChar(IntToStr(round(mousePosition.x))), 56,0,16,WHITE);
        //DrawText(PChar(IntToStr(round(mousePosition.y))), 56,20,16,WHITE);
        //DrawLine(0,round(mousePosition.y),1365,round(mousePosition.y), WHITE);
        //DrawLine(round(mousePosition.x),0,round(mousePosition.x),705,WHITE);
        // resize the rectangle below as per dimensions of your widget:
        //DrawRectangle(round(mousePosition.x), round(mousePosition.y),32,32,ORANGE);
        // or uncomment the following if you need to place a label: 
        //DrawTextEx(fontSButton, '123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 1234567890', mousePosition, 14, 1, clLetter);
        // and write down the coordonates from the upper left corner of the screen.
        // I move (or just copy) this around, from a screen to another 
        //   to help me in layouting the "forms".
        //================= end live ui design =======================
        
        // I use this initially, when no handler is defined
        //if IsKeyPressed(KEY_UP) then begin 
        //  exitWindow := true; //exit
        //end;  
      end;
// =====================================================================
// FIRST KEY "PANEL" 
// =====================================================================
      if (currentScreen = 1) then begin
        //
        clear_fields;
        d_keyfrst(NAME_FLD);
        if (db_status = S_NOTFOUND) then begin 
          squabdb_empty := true;
        end 
        else if (db_status = S_OKAY) then begin
          squabdb_empty := false;
          sbFirst_active := false;
          sbPrev_active := false;
          if (not sbNext_active) then begin
            sbLast_active := true;
            sbNext_active := true;
          end;
          d_recread(@brd);
          if(db_status = S_OKAY) then begin
            breed := brd.name;
            cat := brd.category;
            orig := brd.origin;
            desc := brd.description;
            imgid := brd.imageid;
          end;
        end;
        DrawRectangle(691+48,86,372,372,clBackground);
        load_imageid(imgid, bufferTex);
        currentScreen := 0;
      end;
// =====================================================================
// PREV KEY "PANEL" 
// =====================================================================
      if (currentScreen = 2) then begin
        //
        clear_fields;
        d_keyprev(NAME_FLD);
        if (db_status = S_NOTFOUND) then begin
          d_keyfrst(NAME_FLD);
          if (db_status = S_NOTFOUND) then
            squabdb_empty := true
          else if (db_status = S_OKAY) then begin
            squabdb_empty := false;
            sbFirst_active := false;
            sbPrev_active := false;
            if (not sbNext_active) then begin
              sbNext_active := true;
              sbLast_active := true;
            end;
            d_recread(@brd);
            if(db_status = S_OKAY)then begin
              breed := brd.name;
              cat := brd.category;
              orig := brd.origin;
              desc := brd.description;
              imgid := brd.imageid;
            end;            
          end;  
        end 
        else if (db_status = S_OKAY) then begin
          squabdb_empty := false;
          sbFirst_active := true;
          sbPrev_active := true;
          if (not sbNext_active) then begin
            sbNext_active := true;
            sbLast_active := true;
          end;
          d_recread(@brd);
          if(db_status = S_OKAY) then begin
            breed := brd.name;
            cat := brd.category;
            orig := brd.origin;
            desc := brd.description;
            imgid := brd.imageid;
          end;            
        end;
        DrawRectangle(691+48,86,372,372,clBackground);
        load_imageid(imgid, bufferTex);
        currentScreen := 0;
      end;
// =====================================================================
// NEXT KEY "PANEL" 
// =====================================================================
      if currentScreen = 3 then begin
        //
        clear_fields;
        d_keynext(NAME_FLD);
        if (db_status = S_NOTFOUND) then begin
          d_keylast(NAME_FLD);
          if (db_status = S_NOTFOUND) then
            squabdb_empty := true
          else if (db_status = S_OKAY) then begin
            squabdb_empty := false;
            sbLast_active := false;
            sbNext_active := false;
            if (not sbFirst_active) then begin
              sbPrev_active := true;
              sbFirst_active := true;
            end;
            d_recread(@brd);
            if(db_status = S_OKAY) then begin
              breed := brd.name;
              cat := brd.category;
              orig := brd.origin;
              desc := brd.description;
              imgid := brd.imageid;
            end;            
          end;  
        end 
        else if (db_status = S_OKAY) then begin
          squabdb_empty := false;
          sbFirst_active := true;
          sbPrev_active := true;
          if (not sbFirst_active) then begin
            sbPrev_active := true;
            sbFirst_active := true;
          end;
          d_recread(@brd);
          if(db_status = S_OKAY) then begin
            breed := brd.name;
            cat := brd.category;
            orig := brd.origin;
            desc := brd.description;
            imgid := brd.imageid;
          end;            
        end;
        DrawRectangle(691+48,86,372,372,clBackground);
        load_imageid(imgid, bufferTex);
        currentScreen := 0;
      end;
// =====================================================================
// LAST KEY "PANEL" 
// =====================================================================
      if (currentScreen = 4) then begin
        //
        clear_fields;
        d_keylast(NAME_FLD);
        if (db_status = S_NOTFOUND) then
          squabdb_empty := true;
        if (db_status = S_OKAY) then begin
          squabdb_empty := false;
          sbLast_active := false;
          sbNext_active := false;
          if (not sbFirst_active) then begin
            sbFirst_active := true;
            sbPrev_active := true;
          end;
          d_recread(@brd);
          if(db_status = S_OKAY) then begin
            breed := brd.name;
            cat := brd.category;
            orig := brd.origin;
            desc := brd.description;
            imgid := brd.imageid;
          end;
        end;
        DrawRectangle(691+48,86,372,372,clBackground);
        load_imageid(imgid, bufferTex);
        currentScreen := 0;
      end;
// =====================================================================
// FIND KEY "PANEL" 
// =====================================================================
      if (currentScreen = 5) then begin
        cycle_common := true;
        rec_common.x := 277;
        rec_common.y := 132;
        rec_common.width := 820;
        rec_common.height := 100;
        DrawRectangleRounded(rec_common,0.4,4,DARKGRAY);
        commonPos.x := 293;
        commonPos.y := 173;
        DrawTextEx(fontLabel, 'BREED:', commonPos, 20, 1, LIGHTGRAY);
        rec_common.x := 375;
        rec_common.y := 166;
        rec_common.width := 600;
        rec_common.height := 32;
        if (GuiTextBox(rec_common,@eText,60,iSearchEdit)) then iSearchEdit :=  not iSearchEdit;
        bFindKey_click := GuiButton(RectangleCreate (990, 166, 88, 32), 'Find');
        // EVENTS
        if (bFindKey_click) then begin
          clear_buffer_fields;
          eText := trim(eText);
          //breed_buff := trim(eText);
          d_keyfind(NAME_FLD, @eText);
          if (db_status = S_OKAY) then begin
            d_recread(@brd);
            if(db_status = S_OKAY) then begin
              breed_buff := brd.name;
              cat_buff := brd.category;
              orig_buff := brd.origin;
              desc_buff := brd.description;
              imgid_buff := brd.imageid;
              load_imageid(imgid_buff, bufferTex2);
            end;
            currentScreen := 14;
          end 
          else currentScreen := 13;
        end;
      end;
// =====================================================================
// ADD RECORDS PANEL 
// =====================================================================
      if (currentScreen = 6) then begin
        //
        originated := 6;
        ClearBackground(clBackground);
        DrawRectangle(pMain_posX,pMain_posY,896,640,clPanel); // SECONDARY PANEL
        commonPos.x := 252;
        commonPos.y := 181;
        DrawTextEx(fontLabel, 'BREED NAME:', commonPos, 20, 1, clLabels);
        rec_common.x := 270;
        rec_common.y := 215;
        rec_common.width := 760;
        rec_common.height := 32;
        if (GuiTextBox(rec_common,@eBreed,60, iBreedEdit)) then iBreedEdit := not iBreedEdit;
        commonPos.x := 252;
        commonPos.y := 261;
        DrawTextEx(fontLabel, 'CATEGORY ("High flyer","Roller","Tumbler"):', commonPos, 20, 1, clLabels);
        rec_common.x := 270;
        rec_common.y := 295;
        rec_common.width := 760;
        rec_common.height := 32;
        if (GuiTextBox(rec_common,@eCategory,60,iCategoryEdit)) then iCategoryEdit := not iCategoryEdit;
        commonPos.x := 252;
        commonPos.y := 341;
        DrawTextEx(fontLabel, 'ORIGIN (Town and Country):', commonPos, 20, 1, clLabels);
        rec_common.x := 270;
        rec_common.y := 375;
        rec_common.width := 760;
        rec_common.height := 32;
        if (GuiTextBox(rec_common,@eOrigin,60,iOriginEdit)) then iOriginEdit := not iOriginEdit;
        commonPos.x := 252;
        commonPos.y := 421;
        DrawTextEx(fontLabel, 'IMAGE ID (image file name in "pictures" subfolder):', commonPos, 20, 1, clLabels);
        rec_common.x := 270;
        rec_common.y := 455;
        rec_common.width := 760;
        rec_common.height := 32;
        if (GuiTextBox(rec_common,@eImageid,60,iImageidEdit)) then iImageidEdit := not iImageidEdit;
        commonPos.x := 252;
        commonPos.y := 506;
        DrawTextEx(fontLabel, 'DESCRIPTION (100 characters maxim):', commonPos, 20, 1, clLabels);
        rec_common.x := 270;
        rec_common.y := 544;
        rec_common.width := 760;
        rec_common.height := 32;
        if (GuiTextBox(rec_common,@eDesc1,80, iDesc1Edit)) then iDesc1Edit := not iDesc1Edit;
        rec_common.x := 270;
        rec_common.y := 580;
        rec_common.width := 760;
        rec_common.height := 32;
        if (GuiTextBox(rec_common,@eDesc2,80, iDesc2Edit)) then iDesc2Edit := not iDesc2Edit;
        //
        commonPos.x := pMain_posX;
        commonPos.y := pMain_posY+110;
        commonPos2.x := commonPos.x + 896.0;
        commonPos2.y := commonPos.y;
        DrawLineEx(commonPos, commonPos2, 4.0, clFrames);
        DrawTexture(iAddLarge,192,65,WHITE);
        DrawTextEx(fontTitle, 'Add a new record.', Vector2Create (277,83), 56, 2, clLabels);
        bAddSave_click   := GuiButton(RectangleCreate(461, 630, 88, 32), 'Save');
        bAddCancel_click := GuiButton(RectangleCreate(791, 630, 88, 32), 'Cancel');
        if (bAddSave_click) then begin
          // transfer the fields in the buffer and update the record
          eBreed_buff := trim(eBreed);
          eCategory_buff := trim(eCategory);
          eOrigin_buff := trim(eOrigin);
          eImageid_buff := trim(eImageid);
          eDescription_buff := trimleft(eDesc1);
          eDescription_buff := eDescription_buff + trimright(eDesc2);
          //
          add_err := 0;
          if (eBreed_buff = '') then begin
            add_err := 1;
            err_msg := 'The key (breed) cannot be empty!';
          end;
          if (eCategory_buff = '') then begin
            add_err := 1;
            err_msg := 'The category cannot be empty!';
          end;
          if (eDescription_buff = '') then begin
            add_err := 1;
            err_msg := 'The description cannot be empty!';
          end;
          if (eImageid_buff = '') then
            eImageid_buff := 'noimage.png';
          // display error:
          if(add_err > 0) then currentScreen := 17;
          if (add_err = 0) then begin
            // 
            // ADD NEW RECORD!
            //
            brd.name := eBreed_buff;
            brd.category := eCategory_buff;
            brd.origin := eOrigin_buff;
            brd.description := eDescription_buff;
            brd.imageid := eImageid_buff;
            if (d_keyfind(NAME_FLD,@eBreed_buff) = S_NOTFOUND) then begin
              if (d_fillnew(BREEDS_TBL, @brd) = S_OKAY) then begin
                d_recread(@brd);
                if(db_status = S_OKAY) then begin
                  breed := brd.name;
                  cat := brd.category;
                  orig := brd.origin;
                  desc := brd.description;
                  imgid := brd.imageid;
                end;
                //
                if (squabdb_empty) then begin
                  squabdb_empty := false;
                  sbFirst_active := false;
                  sbNext_active  := true;
                  sbFind_active  := true;
                  sbAdd_active   := true;
                  sbMod_active   := true;
                  sbDel_active   := true;
                end;
                clear_add_fields;
                clear_buffer_fields;
                DrawRectangle(691+48,86,372,372,clBackground);
                load_imageid(imgid, bufferTex);
                currentScreen := 1; // jump to the first key in the database
              end 
              else writeln('Error adding a new record!');
            end 
            else begin
              currentScreen := 17;
              err_msg := 'Sorry, this breed is already here!'; 
            end;
          end;
        end;
        if (bAddCancel_click) then begin
          // no transfer...
          currentScreen := 0;
        end;
      end;
// =====================================================================
// MODIFY RECORDS PANEL 
// =====================================================================
      if (currentScreen = 7) then begin
        //
        originated := 7;
        ClearBackground(clBackground);
        DrawRectangle(pMain_posX,pMain_posY,896,640,clPanel); // SECONDARY PANEL
        commonPos.x := 252;
        commonPos.y := 181;
        DrawTextEx(fontLabel, 'BREED NAME:', commonPos, 20, 1, clLabels);
        commonPos.x := 270;
        commonPos.y := 215;
        DrawTextEx(fontLetter, @breed[1], commonPos, 24,1,clLabels);
        commonPos.x := 252;
        commonPos.y := 261;
        DrawTextEx(fontLabel, 'CATEGORY:', commonPos, 20, 1, clLabels);
        if (GuiTextBox(RectangleCreate(270,295,760,32),@eCategory[0],60,iCategoryEdit)) then iCategoryEdit := not iCategoryEdit;
        commonPos.x := 252;
        commonPos.y := 341;
        DrawTextEx(fontLabel, 'ORIGIN:', commonPos, 20, 1, clLabels);
        rec_common.x := 270;
        rec_common.y := 375;
        rec_common.width := 760;
        rec_common.height := 32;
        if (GuiTextBox(rec_common,@eOrigin,60,iOriginEdit)) then iOriginEdit := not iOriginEdit;
        commonPos.x := 252;
        commonPos.y := 421;
        DrawTextEx(fontLabel, 'IMAGE ID:', commonPos, 20, 1, clLabels);
        rec_common.x := 270;
        rec_common.y := 455;
        rec_common.width := 760;
        rec_common.height := 32;
        if (GuiTextBox(rec_common,@eImageid,60,iImageidEdit)) then iImageidEdit := not iImageidEdit;
        commonPos.x := 252;
        commonPos.y := 506;
        DrawTextEx(fontLabel, 'DESCRIPTION:', commonPos, 20, 1, clLabels);
        rec_common.x := 270;
        rec_common.y := 544;
        rec_common.width := 760;
        rec_common.height := 32;
        if (GuiTextBox(rec_common,@eDesc1,80, iDesc1Edit)) then iDesc1Edit := not iDesc1Edit;
        rec_common.x := 270;
        rec_common.y := 580;
        rec_common.width := 760;
        rec_common.height := 32;
        if (GuiTextBox(rec_common,@eDesc2,80, iDesc2Edit)) then iDesc2Edit := not iDesc2Edit;
        //
        commonPos.x := pMain_posX;
        commonPos.y := pMain_posY+110;
        commonPos2.x := commonPos.x + 896.0;
        commonPos2.y := commonPos.y;
        DrawLineEx(commonPos, commonPos2, 4.0, clFrames);
        DrawTexture(iModLarge,201,65,WHITE);
        DrawTextEx(fontTitle, 'Modify the record (navigation).', Vector2Create(277,83), 56, 2, clLabels);
        bModSave_click := GuiButton(RectangleCreate(461, 630, 88, 32), 'Save');
        bModCancel_click := GuiButton(RectangleCreate(791, 630, 88, 32), 'Cancel');
        if (bModSave_click) then begin
          mod_err := 0;
          // transfer the fields in the buffer and update the record if no err
          cat := trim(eCategory);
          orig := trim(eOrigin);
          imgid := trim(eImageid);
          desc := trimleft(eDesc1);
          desc := desc + trimright(eDesc2);
          if (cat = '') then begin
            mod_err := 1;
            err_msg := 'Category cannot be empty!';
          end;
          if (orig = '') then begin
            mod_err := 1;
            err_msg := 'Origin cannot be empty!';
          end;
          if (desc = '') then begin
            mod_err := 1;
            err_msg := 'Description cannot be empty!';
          end;
          if (imgid = '') then begin
            imgid := 'noimage.png';
          end;
          if(mod_err > 0) then currentScreen := 17;
          if(mod_err = 0) then begin
            currentScreen := 0;
            //
            // UPDATE THE RECORD!
            //
            brd.name := breed;
            brd.category := cat;
            brd.origin := orig;
            brd.description := desc;
            brd.imageid := imgid;
            if(d_recwrite(@brd) = S_OKAY ) then begin
              writeln('Record updated!');
              d_recread(@brd);
              if(db_status = S_OKAY) then begin
                breed := brd.name;
                cat := brd.category;
                orig := brd.origin;
                desc := brd.description;
                imgid := brd.imageid;
              end; 
            end
            else 
              writeln('Error updating the record!');
          end;
        end;
        if (bModCancel_click) then begin
          // no transfer...
          currentScreen := 0;
          d_recread(@brd);
          if(db_status = S_OKAY) then begin
            breed := brd.name;
            cat := brd.category;
            orig := brd.origin;
            desc := brd.description;
            imgid := brd.imageid;
          end; 
        end;
      end;
// =====================================================================
// DELETE RECORDS "PANEL" 
// =====================================================================
      if currentScreen = 8 then begin
        //
        rec_common.x := 326;
        rec_common.y := 508;
        rec_common.width := 660;
        rec_common.height := 100;
        DrawRectangleRounded(rec_common, 0.2,4,clBrick);
        rec_common.x := 441;
        rec_common.y := 589;
        rec_common.width := 100;
        rec_common.height := 40;
        DrawRectangleRounded(rec_common, 0.6,4,clBrick);
        rec_common.x := 771;
        rec_common.y := 589;
        rec_common.width := 100;
        rec_common.height := 40;
        DrawRectangleRounded(rec_common, 0.6,4,clBrick);
        commonPos.x := 501;
        commonPos.y := 542; 
        DrawTextEx(fontLabel, 'Do you really want to delete this record?', commonPos, 20, 1, WHITE);
        bDelYes_click := GuiButton(RectangleCreate(461, 590, 60, 28), 'Yes');
        bDelNo_click := GuiButton(RectangleCreate(791, 590, 60, 28), 'No');
        if bDelNo_click then 
          currentScreen := 0;
        if bDelYes_click then begin
          currentScreen := 1; // go to reading the first key...
          if(d_delete() = S_OKAY) then writeln('Record deleted!') 
          else  writeln('Error deleting the record!');
        end;
      end;
// =====================================================================
// ABOUT PANEL 
// =====================================================================
      if currentScreen = 10 then begin
        stp := 60;
        ClearBackground(clBackground);
        DrawTexture(iGrass1a, pSplash_posX-82, pSplash_posY + 285, WHITE);
        DrawTexture(iAbout, 890, 11, WHITE);
        DrawRectangle(pSplash_posX,pSplash_posY,896-200,664-204,clPanel);
        //DrawTexture(iPigeon_Bye, 200,100, WHITE);
        if cbTheme_idx = 0 then begin // dark theme
          DrawTexture(iFirefly2, 236, 494, WHITE);
          DrawTexture(iFirefly1, 298, 478, WHITE);
        end
        else // light theme
          DrawTexture(iLadybug, 291, 516, WHITE);
        //  
        commonPos.x := single(pSplash_posX + 20);
        commonPos.y := single(pSplash_posY + 10);
        DrawTextEx(fontTitle, 'Actually, I wanna give thanks:', commonPos, 56, 2, clLabels);
        commonPos.x := single(pSplash_posX + 20);
        commonPos.y := single(pSplash_posY + stp + 75);
        DrawTextEx(fontLetter, '- to Lorena, my daughter for graphics advising;', commonPos, 24, 2, clLabels);
        commonPos.x := single(pSplash_posX + 20);
        commonPos.y := single(pSplash_posY + stp + 103);
        DrawTextEx(fontLetter, '- to FreePascal team and forums;', commonPos, 24, 2, clLabels);
        commonPos.x := single(pSplash_posX + 20);
        commonPos.y := single(pSplash_posY + stp + 131);
        DrawTextEx(fontLetter, '- to Gunko Vadim for raylib pascal translation;', commonPos, 24, 2, clLabels);
        commonPos.x := single(pSplash_posX + 20);
        commonPos.y := single(pSplash_posY + stp + 159);
        DrawTextEx(fontLetter, '- to Thomas B. Pedersen, original developer of typhoon;', commonPos, 24, 2, clLabels);
        commonPos.x := single(pSplash_posX + 20);
        commonPos.y := single(pSplash_posY + stp + 187);
        DrawTextEx(fontLetter, '- to Kaz Kylheku for update on typhoon library;', commonPos, 24, 2, clLabels);
        commonPos.x := single(pSplash_posX + 20);
        commonPos.y := single(pSplash_posY + stp + 215);
        DrawTextEx(fontLetter, '- to Ramon Santamaria and raylib development team.', commonPos, 24, 2, clLabels);
        bQuitYes_click := GuiButton(RectangleCreate(pSplash_posX + 315, pSplash_posY + 398, 88, 32), 'OK');
        if bQuitYes_click then begin 
          currentScreen := 0;
        end;  
        //
      end;
// =====================================================================
// EXIT PANEL 
// =====================================================================
      if currentScreen = 11 then begin
        ClearBackground(clBackground);
        DrawRectangle(pSplash_posX,pSplash_posY,896-200,664-204,clPanel);
        DrawTexture(iPigeon_Bye, 200,100, WHITE);
        commonPos.x := single(pSplash_posX + 320);
        commonPos.y := single(pSplash_posY + 130);
        DrawTextEx(fontTitle, 'Quitting?', commonPos, 56, 2, clLabels);
        commonPos.x := single(pSplash_posX + 280);
        commonPos.y := single(pSplash_posY + 230);
        DrawTextEx(fontLetter, '... it seems you wanna leave...', commonPos, 24, 2, clLabels);
        DrawTexture(iSlime1, pSplash_posX + 105,pSplash_posY + 420, WHITE);
        DrawTexture(iSlime2, pSplash_posX + 136,pSplash_posY + 355, WHITE);
        bQuitYes_click := GuiButton(RectangleCreate(pSplash_posX + 100, pSplash_posY + 398, 88, 32), 'Yes');
        bQuitNo_click := GuiButton(RectangleCreate(pSplash_posX + 530, pSplash_posY + 398, 88, 32), 'No');
        if bQuitYes_click then begin 
          exitWindow := true;
        end;  
        if bQuitNo_click then begin 
          currentScreen := 0;
        end;  
      end;
// =====================================================================
// ERROR NEXTKEY "PANEL" - not used, reminiscence from qdbm database
// =====================================================================
      if currentScreen = 12 then begin
        //ClearBackground(clBackground);
        rec_common.x := 326;
        rec_common.y := 508;
        rec_common.width := 660;
        rec_common.height := 100;
        DrawRectangleRounded(rec_common, 0.2,4,clBrick);
        rec_common.x := 611;
        rec_common.y := 589;
        rec_common.width := 100;
        rec_common.height := 40;
        DrawRectangleRounded(rec_common, 0.6,4,clBrick);
        commonPos.x := 546;
        commonPos.y := 542; 
        DrawTextEx(fontLabel, 'Already at the last record!', commonPos, 20, 1, WHITE);
        bErrorNextKey_click := GuiButton(RectangleCreate(631, 590, 60, 28), 'Ok');
        if bErrorNextKey_click then begin 
          currentScreen := originated;
          bErrorNextKey_click := false;
        end;          
      end;
// =====================================================================
// ERROR FIND KEY "PANEL" 
// =====================================================================
      if currentScreen = 13 then begin
        //ClearBackground(clBackground);
        rec_common.x := 326;
        rec_common.y := 508;
        rec_common.width := 660;
        rec_common.height := 100;
        DrawRectangleRounded(rec_common, 0.2,4,clBrick);
        rec_common.x := 611;
        rec_common.y := 589;
        rec_common.width := 100;
        rec_common.height := 40;
        DrawRectangleRounded(rec_common, 0.6,4,clBrick);
        commonPos.x := 540;
        commonPos.y := 542; 
        DrawTextEx(fontLabel, 'Sorry, there is no such key!', commonPos, 20, 1, WHITE);
        bErrorFindKey_click := GuiButton(RectangleCreate(631, 590, 60, 28), 'Ok');
        if (bErrorFindKey_click or IsKeyPressed(KEY_ENTER)) then begin 
          currentScreen := originated;
          bErrorFindKey_click := false;
        end;          
      end;
// =====================================================================
// FIND RESULT PANEL 
// =====================================================================
      if (currentScreen = 14) then begin
        //
        originated := 14;
        ClearBackground(clBackground);
        DrawRectangle(pMain_posX,pMain_posY,896,600,clPanel);
        commonPos.x := 252;
        commonPos.y := 181;
        DrawTextEx(fontLabel, 'BREED NAME:', commonPos, 20, 1, clLabels);
        commonPos.x := 270;
        commonPos.y := 215;
        if (breed_buff = '') then
          DrawTextEx(fontLetter, '...', commonPos, 24, 1, clLabels)
        else
          DrawTextEx(fontLetter, @breed_buff[1], commonPos, 24, 1, clLabels);
        commonPos.x := 252;
        commonPos.y := 261;
        DrawTextEx(fontLabel, 'CATEGORY:', commonPos, 20, 1, clLabels);
        commonPos.x := 270;
        commonPos.y := 295;
        if (cat_buff = '') then
          DrawTextEx(fontLetter, '...', commonPos, 24, 1, clLabels)
        else
          DrawTextEx(fontLetter, @cat_buff[1], commonPos, 24, 1, clLabels);
        commonPos.x := 252;
        commonPos.y := 341;
        DrawTextEx(fontLabel, 'ORIGIN:', commonPos, 20, 1, clLabels);
        commonPos.x := 270;
        commonPos.y := 375;
        if (orig_buff = '') then
          DrawTextEx(fontLetter, '...', commonPos, 24, 1, clLabels)
        else
          DrawTextEx(fontLetter, @orig_buff[1], commonPos, 24, 1, clLabels);
        commonPos.x := 252;
        commonPos.y := 506;
        DrawTextEx(fontLabel, 'DESCRIPTION:', commonPos, 20, 1, clLabels);
        commonPos.x := 270;
        commonPos.y := 544;
        DrawTextEx(fontDesc, @desc_buff[1], commonPos, 16, 1, clLabels);
        //
        // draw lines and photo frame
        commonPos.x := pMain_posX;
        commonPos.y := pMain_posY+110;
        commonPos2.x := commonPos.x + 896.0;
        commonPos2.y := commonPos.y;
        DrawLineEx(commonPos, commonPos2, 4.0, clFrames);
        DrawTexture(iFindLarge,189,13,WHITE);
        DrawTextEx(fontTitle, 'I Found It!', Vector2Create(337,83), 56, 2, clLabels);
        rec_common.x := 677;
        rec_common.y := 72;
        rec_common.width := 400;
        rec_common.height := 400;
        DrawRectangleRounded(rec_common,0.1,4,clPhoto);
        if (imgid_buff = '') then
          DrawTexture(iNoImage,691,86,WHITE)
        else
          DrawTexture(bufferTex2,691,86,WHITE);

        bResultMod_click := GuiButton(RectangleCreate(762, 576, 88, 32), 'Modify');
        bResultDel_click := GuiButton(RectangleCreate(862, 576, 88, 32), 'Delete');
        bResultClose_click := GuiButton(RectangleCreate(962, 576, 88, 32), 'Close');

        if ((bResultClose_click) or (IsKeyPressed(KEY_C))) then begin
          currentScreen := 1;
          bResultClose_click := false;
        end;
        if ((bResultDel_click) or (IsKeyPressed(KEY_D))) then begin
          currentScreen := 15;
          bResultDel_click := false;
        end;
        if ((bResultMod_click) or (IsKeyPressed(KEY_M))) then begin
          ln := length(desc_buff);
          currentScreen := 16;
          bResultMod_click := false;
          eCategory_buff := cat_buff;
          eOrigin_buff := orig_buff;
          eImageid_buff := imgid_buff;
          if (ln <=80) then begin
            eDesc1_buff := desc_buff;
            eDesc2_buff := '';
          end 
          else begin
            eDesc1_buff := copy(desc_buff, 1, 80);
            eDesc2_buff := copy(desc_buff, 81, ln-80);
          end;
        end;
      end;
// =====================================================================
// FIND RESULT DELETE - PANEL 
// =====================================================================
      if currentScreen = 15 then begin
        originated := 14;
        rec_common.x := 326;
        rec_common.y := 508;
        rec_common.width := 660;
        rec_common.height := 100;
        DrawRectangleRounded(rec_common, 0.2,4,clBrick);
        rec_common.x := 441;
        rec_common.y := 589;
        rec_common.width := 100;
        rec_common.height := 40;
        DrawRectangleRounded(rec_common, 0.6,4,clBrick);
        rec_common.x := 771;
        rec_common.y := 589;
        rec_common.width := 100;
        rec_common.height := 40;
        DrawRectangleRounded(rec_common, 0.6,4,clBrick);
        commonPos.x := 501;
        commonPos.y := 542; 
        DrawTextEx(fontLabel, 'Do you really want to delete this record?', commonPos, 20, 1, WHITE);
        bResultDelYes_click := GuiButton(RectangleCreate(461, 590, 60, 28), 'Yes');
        bResultDelNo_click := GuiButton(RectangleCreate(791, 590, 60, 28), 'No');
        if (bResultDelNo_click or IsKeyPressed(KEY_N)) then
          currentScreen := 14;
        if (bResultDelYes_click  or IsKeyPressed(KEY_Y)) then begin
          currentScreen := 1;
          if(d_delete() <> S_OKAY) then
            writeln('Record cannot be deleted!');
        end;
      end;
// =====================================================================
// MODIFY RECORDS PANEL 
// =====================================================================
      if (currentScreen = 16) then begin
        originated := 16;
        ClearBackground(clBackground);
        DrawRectangle(pMain_posX,pMain_posY,896,640,clPanel); // SECONDARY PANEL
        commonPos.x := 252;
        commonPos.y := 181;
        DrawTextEx(fontLabel, 'BREED NAME:', commonPos, 20, 1, clLabels);
        commonPos.x := 270;
        commonPos.y := 215;
        DrawTextEx(fontLetter, @breed_buff[1],commonPos, 24,1,clLabels);
        commonPos.x := 252;
        commonPos.y := 261;
        DrawTextEx(fontLabel, 'CATEGORY:', commonPos, 20, 1, clLabels);
        if (GuiTextBox(RectangleCreate(270,295,760,32),eCategory_buff,60,iCategoryEdit)) then iCategoryEdit := not iCategoryEdit;
        commonPos.x := 252;
        commonPos.y := 341;
        DrawTextEx(fontLabel, 'ORIGIN:', commonPos, 20, 1, clLabels);
        rec_common.x := 270;
        rec_common.y := 375;
        rec_common.width := 760;
        rec_common.height := 32;
        if (GuiTextBox(rec_common,eOrigin_buff,60,iOriginEdit)) then iOriginEdit :=  not iOriginEdit;
        commonPos.x := 252;
        commonPos.y := 421;
        DrawTextEx(fontLabel, 'IMAGE ID:', commonPos, 20, 1, clLabels);
        rec_common.x := 270;
        rec_common.y := 455;
        rec_common.width := 760;
        rec_common.height := 32;
        if (GuiTextBox(rec_common,eImageid_buff,60,iImageidEdit)) then iImageidEdit := not iImageidEdit;
        commonPos.x := 252;
        commonPos.y := 506;
        DrawTextEx(fontLabel, 'DESCRIPTION:', commonPos, 20, 1, clLabels);
        rec_common.x := 270;
        rec_common.y := 544;
        rec_common.width := 760;
        rec_common.height := 32;
        if (GuiTextBox(rec_common,eDesc1_buff,80, iDesc1Edit)) then iDesc1Edit := not iDesc1Edit;
        rec_common.x := 270;
        rec_common.y := 580;
        rec_common.width := 760;
        rec_common.height := 32;
        if (GuiTextBox(rec_common,eDesc2_buff,80, iDesc2Edit)) then iDesc2Edit := not iDesc2Edit;
        //
        commonPos.x := pMain_posX;
        commonPos.y := pMain_posY+110;
        commonPos2.x := commonPos.x + 896.0;
        commonPos2.y := commonPos.y;
        DrawLineEx(commonPos, commonPos2, 4.0, clFrames);
        DrawTexture(iModLarge,201,65,WHITE);
        DrawTextEx(fontTitle, 'Modify the record (search result).', Vector2Create(277,83), 56, 2, clLabels);
        bModSave_click := GuiButton(RectangleCreate (461, 630, 88, 32), 'Save');
        bModCancel_click := GuiButton(RectangleCreate(791, 630, 88, 32), 'Cancel');
        if (bModSave_click) then begin
          mod_err := 0;
          // transfer the fields in the buffer and update the record if no err
          cat_buff := trim(eCategory_buff);
          orig_buff := trim(eOrigin_buff);
          imgid_buff := trim(eImageid_buff);
          desc_buff := trimleft(eDesc1_buff);
          desc_buff := trimright(eDesc2_buff);
          if (cat_buff = '') then begin
            mod_err := 1;
            err_msg := 'Category cannot be empty!';
          end;
          if (orig_buff = '') then begin
            mod_err := 1;
            err_msg := 'Origin cannot be empty!';
          end;
          if (desc_buff = '') then begin
            mod_err := 1;
            err_msg := 'Description cannot be empty!';
          end;
          if (imgid_buff = '') then
            imgid_buff := 'noimage.png';
          if (mod_err > 0) then currentScreen := 17;
          if (mod_err = 0) then begin
            currentScreen := 14;
            brd.name := breed_buff;
            brd.category := cat_buff;
            brd.origin := orig_buff;
            brd.description := desc_buff;
            brd.imageid := imgid_buff;
            if(d_recwrite(@brd) = S_OKAY ) then begin
              writeln('Record updated!');
            end;
            load_imageid(imgid_buff, bufferTex2);
          end;
        end;
        if (bModCancel_click) then begin
          // no transfer...
          currentScreen := 14;
        end;
      end;
// =====================================================================
// ERRORS FROM ADD AND MOD SCREENS
// =====================================================================
      if (currentScreen = 17) then begin
        //
        rec_common.x := 326;
        rec_common.y := 508;
        rec_common.width := 660;
        rec_common.height := 100;
        DrawRectangleRounded(rec_common, 0.2,4,clBrick);
        rec_common.x := 611;
        rec_common.y := 589;
        rec_common.width := 100;
        rec_common.height := 40;
        DrawRectangleRounded(rec_common, 0.6,4,clBrick);
        commonPos.x := 440;
        commonPos.y := 542;
        DrawTextEx(fontLabel, @err_msg[1], commonPos, 20, 1, WHITE);
        bErrorAddKey_click := GuiButton(RectangleCreate(631, 590, 60, 28), 'Ok');
        if ((bErrorAddKey_click) or (IsKeyPressed(KEY_ENTER))) then begin
          currentScreen := originated;
          bErrorAddKey_click := false;
        end;
      end;
      //////////////////////
      EndDrawing();
    end;
    d_close(); // close database
    // De-Initialization
    UnloadTexture(sbDel_gray);
    UnloadTexture(sbMod_gray);
    UnloadTexture(sbAdd_gray);
    UnloadTexture(sbFind_gray);
    UnloadTexture(sbLast_gray);
    UnloadTexture(sbNext_gray);
    UnloadTexture(sbPrev_gray);
    UnloadTexture(sbFirst_gray);
    //
    UnloadTexture(sbExit);
    UnloadTexture(sbInfo);
    UnloadTexture(sbDel);
    UnloadTexture(sbMod);
    UnloadTexture(sbAdd);
    UnloadTexture(sbFind);
    UnloadTexture(sbLast);
    UnloadTexture(sbNext);
    UnloadTexture(sbPrev);
    UnloadTexture(sbFirst);
    //
    UnloadTexture(iGrass2b); 
    UnloadTexture(iGrass1a);   
    UnloadTexture(iSlime2);   
    UnloadTexture(iSlime1);   
    UnloadTexture(iAbout);   
    UnloadTexture(iPigeon_Bye); 
    UnloadTexture(iPigeon_Welcome); 
    //
    UnloadFont(fontDesc);
    UnloadFont(fontSButton);
    UnloadFont(fontLabel);
    UnloadFont(fontLetter);
    UnloadFont(fontTitle);
    //
    UnloadTexture(iNoImage);  
    UnloadTexture(bufferTex);
    UnloadTexture(bufferTex2);
    UnloadTexture(iFirefly1);
    UnloadTexture(iFirefly2);
    UnloadTexture(iLadybug);
    UnloadTexture(iFindLarge);
    UnloadTexture(iModLarge);
    UnloadTexture(iAddLarge);
    //--------------------------------------------------------------------
    CloseWindow();        // Close window and OpenGL context
    //--------------------------------------------------------------------
  end
  else writeln('Error opening database!');
end.
