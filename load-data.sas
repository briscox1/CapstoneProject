*contents of uploaded datset;
proc contents data=mysaslib.capstone order=varnum;
	ods select position;
	title 'Original Variables in dataset obtained from kaggle.com';
run; quit;

* rename variables to match second dataset;
data capstone2;
	set mysaslib.capstone (rename=(duration_ms=spotify_track_duration_ms explicit=spotify_track_explicit
						   artists=performer name=song popularity=spotify_track_popularity));
run; quit;

proc contents data=capstone2 order=varnum;
	ods select position;
	title 'Variables in dataset obtained from kaggle.com after renaming variables';
run; quit;

proc means data=capstone2 n nmiss mean min max sum;
	title 'Descriptive statistics of dataset obtained from kaggle.com';
run; quit;

* view contents of original merged file;
proc contents data=mysaslib.merged order=varnum;
	ods select position;
	title 'Original Variables In the Merged Dataset Obtained From data.world.com';
run; quit;

proc means data=mysaslib.merged n nmiss mean std min max sum;
	title 'Descriptive Statistics of Merged Dataset Obtained From data.world.com';
run; quit;

proc sql;
	select count(*)
	from mysaslib.merged
	where spotify_track_explicit -- time_signature = 0;
	title 'Count of tracks with statistics set to zero';
run; quit;
  
data merged1;
	set mysaslib.merged;
	* remove quotes and double quotes from song titles;
	compressSongId = compress(songId, "'""");
	* if the song made it to the week 1 position, mark the song as a hit;
	if week_position = 1 then hit = 1;
		else hit = 0;
	* delete records with missing values;
	if spotify_track_popularity = . then delete;
	* delete records where the data contains nothing but zeros;
	if spotify_track_explicit -- time_signature = 0 then delete;
run; quit;

* add hit per songID;
data merged2;
	set merged1;
if compressSongId in ("(Cant Live Without Your) Love And AffectionNelson","(Everything I Do) I Do It For YouBryan Adams","(Hey Wont You Play) Another Somebody Done Somebody Wrong SongB.J. Thomas",
"(I Cant Get No) SatisfactionThe Rolling Stones","(I Just) Died In Your ArmsCutting Crew","(Ive Had) The Time Of My LifeBill Medley & Jennifer Warnes","(Just Like) Starting OverJohn Lennon",
"(Love Is) Thicker Than WaterAndy Gibb","(Shake, Shake, Shake) Shake Your BootyKC And The Sunshine Band","(Sittin On) The Dock Of The BayOtis Redding","(They Long To Be) Close To YouCarpenters","(Youre My) Soul And InspirationThe Righteous Brothers",
"(Youre) Having My BabyPaul Anka with Odia Coates","...Baby One More TimeBritney Spears","21 Questions50 Cent Featuring Nate Dogg","3Britney Spears","4 Seasons Of LonelinessBoyz II Men","50 Ways To Leave Your LoverPaul Simon","7 RingsAriana Grande",
"9 To 5Dolly Parton","96 Tears? (Question Mark) & The Mysterians","A Big Hunk O LoveElvis Presley With The Jordanaires","A Fifth Of BeethovenWalter Murphy & The Big Apple Band","A Hard Days NightThe Beatles","A Horse With No NameAmerica",
"A Moment Like ThisKelly Clarkson","A View To A KillDuran Duran","A Whole New World (Aladdins Theme)Peabo Bryson & Regina Belle","A World Without LovePeter And Gordon","ABCJackson 5","ANNIEs SONGJohn Denver","AbracadabraThe Steve Miller Band",
"Addicted To LoveRobert Palmer","AfricaToto","Afternoon DelightStarland Vocal Band","AgainJanet Jackson","Against All Odds (Take A Look At Me Now)Phil Collins","Aint It FunnyJennifer Lopez Featuring Ja Rule","Aint No Mountain High EnoughDiana Ross",
"All 4 LoveColor Me Badd","All About That BassMeghan Trainor","All For LoveBryan Adams/Rod Stewart/Sting","All For YouJanet","All I HaveJennifer Lopez Featuring LL Cool J","All I Want For Christmas Is YouMariah Carey","All My LifeK-Ci & JoJo",
"All Night Long (All Night)Lionel Richie","All Of MeJohn Legend","All The Man That I NeedWhitney Houston","All You Need Is LoveThe Beatles","Alley-OopHollywood Argyles","Alone Again (Naturally)Gilbert OSullivan","AloneHeart","Always Be My BabyMariah Carey",
"Always On TimeJa Rule Featuring Ashanti","AlwaysAtlantic Starr","AmandaBoston","AmazedLonestar","American Pie (Parts I & II)Don McLean","American Woman/No Sugar TonightThe Guess Who","Angel Of MineMonica","AngelShaggy Featuring Rayvon",
"Angie BabyHelen Reddy","AngieThe Rolling Stones","Another Brick In The Wall (Part II)Pink Floyd","Another Day In ParadisePhil Collins","Another One Bites The DustQueen","Anything For YouGloria Estefan & Miami Sound Machine",
"Aquarius/Let The Sunshine InThe 5th Dimension","Are You Lonesome To-night?Elvis Presley With The Jordanaires","Arthurs Theme (Best That You Can Do)Christopher Cross","At This MomentBilly Vera & The Beaters","BabeStyx","Baby BabyAmy Grant",
"Baby BoyBeyonce Featuring Sean Paul","Baby Come BackPlayer","Baby Dont Forget My NumberMilli Vanilli","Baby Dont Get Hooked On MeMac Davis","Baby Got BackSir Mix-A-Lot","Baby LoveThe Supremes","Baby, Come To MePatti Austin With James Ingram",
"Baby, I Love Your Way/Freebird MedleyWill To Power","Back In My Arms AgainThe Supremes","Bad And BoujeeMigos Featuring Lil Uzi Vert","Bad BloodNeil Sedaka","Bad BloodTaylor Swift Featuring Kendrick Lamar","Bad DayDaniel Powter","Bad GirlsDonna Summer",
"Bad GuyBillie Eilish","Bad MedicineBon Jovi","Bad, Bad Leroy BrownJim Croce","BadMichael Jackson","BailamosEnrique Iglesias","Band On The RunPaul McCartney And Wings","Batdance (From Batman)Prince","Be With YouEnrique Iglesias","Beat ItMichael Jackson",
"Beautiful GirlsSean Kingston","Because I Love You (The Postman Song)Stevie B","Because You Loved Me (From Up Close & Personal)Celine Dion","Before The Next Teardrop FallsFreddy Fender","BelieveCher","BenMichael Jackson","Bennie And The JetsElton John",
"Bentmatchbox twenty","Best Of My LoveEagles","Best Of My LoveThe Emotions","Bette Davis EyesKim Carnes","Big Bad JohnJimmy Dean","Big Girls Dont CryFergie","Big Girls Dont CryThe 4 Seasons","Billie JeanMichael Jackson","Bills, Bills, BillsDestinys Child",
"Billy, Dont Be A HeroBo Donaldson And The Heywoods","Black & WhiteThree Dog Night","Black And YellowWiz Khalifa","Black BeatlesRae Sremmurd Featuring Gucci Mane","Black CatJanet Jackson","Black Or WhiteMichael Jackson","Black VelvetAlannah Myles",
"Black WaterThe Doobie Brothers","Blame It On The RainMilli Vanilli","Blank SpaceTaylor Swift","Blaze Of Glory (From Young Guns II)Jon Bon Jovi","Bleeding LoveLeona Lewis","Blinded By The LightManfred Manns Earth Band","Blinding LightsThe Weeknd",
"Blue MoonThe Marcels","Blue VelvetBobby Vinton","Blurred LinesRobin Thicke Featuring T.I. + Pharrell","Bodak Yellow (Money Moves)Cardi B","Boogie FeverThe Sylvers","Boogie Oogie OogieA Taste Of Honey","Boom Boom PowThe Black Eyed Peas",
"BootyliciousDestinys Child","Born This WayLady Gaga","Brand New KeyMelanie","Brandy (Youre A Fine Girl)Looking Glass","Break Your HeartTaio Cruz Featuring Ludacris","Breaking Up Is Hard To DoNeil Sedaka","Bridge Over Troubled WaterSimon & Garfunkel",
"Broken WingsMr. Mister","Brother LouieStories","Brown SugarThe Rolling Stones","Bump N GrindR. Kelly","Bump, Bump, BumpB2K & P. Diddy","BurnUsher","ButterflyCrazy Town","Buy U A Drank (Shawty Snappin)T-Pain Featuring Yung Joc",
"CalcuttaLawrence Welk And His Orchestra","California GurlsKaty Perry Featuring Snoop Dogg","Call Me MaybeCarly Rae Jepsen","Call MeBlondie","Candle In The Wind 1997/Something About The Way You Look TonightElton John","Candy Shop50 Cent Featuring Olivia",
"Cant Buy Me LoveThe Beatles","Cant Feel My FaceThe Weeknd","Cant Fight This FeelingREO Speedwagon","Cant Get Enough Of Your Love, BabeBarry White","Cant Help Falling In Love (From Sliver)UB40","Cant Hold UsMacklemore & Ryan Lewis Featuring Ray Dalton",
"Cant Nobody Hold Me DownPuff Daddy (Featuring Mase)","Cant Stop The Feeling!Justin Timberlake","Car WashRose Royce","CardiganTaylor Swift","Careless WhisperWham! Featuring George Michael","Caribbean Queen (No More Love On The Run)Billy Ocean",
"Cathys ClownThe Everly Brothers","Cats In The CradleHarry Chapin","CelebrationKool & The Gang","CenterfoldThe J. Geils Band","Chapel Of LoveThe Dixie Cups","Chariots Of Fire - TitlesVangelis","Cheap ThrillsSia Featuring Sean Paul",
"Check On ItBeyonce Featuring Slim Thug","CheerleaderOMI","CherishThe Association","CirclesPost Malone","Close To YouMaxi Priest","CloserThe Chainsmokers Featuring Halsey","Cold HeartedPaula Abdul","Come On EileenDexys Midnight Runners",
"Come On Over Baby (All I Want Is You)Christina Aguilera","Come See About MeThe Supremes","Come Softly To MeThe Fleetwoods","Come Together/SomethingThe Beatles","Coming Out Of The DarkGloria Estefan","Coming Up (Live At Glasgow)Paul McCartney And Wings",
"Confessions Part IIUsher","ConvoyC.W. McCall","Couldve BeenTiffany","Crack A BottleEminem, Dr. Dre & 50 Cent","Cracklin RosieNeil Diamond","Crank That (Soulja Boy)Soulja Boy Tellem","Crazy For YouMadonna","Crazy In LoveBeyonce Featuring Jay Z",
"Crazy Little Thing Called LoveQueen","CreamPrince And The N.P.G.","CreepTLC","Crimson And CloverTommy James And The Shondells","Crocodile RockElton John","Da Doo Ron RonShaun Cassidy","Da Ya Think Im Sexy?Rod Stewart","Dancing QueenABBA",
"Dark HorseKaty Perry Featuring Juicy J","Dark LadyCher","Daydream BelieverThe Monkees","December, 1963 (Oh, What a Night)The 4 Seasons","Deep PurpleNino Tempo & April Stevens","Delta DawnHelen Reddy","DespacitoLuis Fonsi & Daddy Yankee Featuring Justin Bieber",
"DiamondsRihanna","Didnt We Almost Have It AllWhitney Houston","DilemmaNelly Featuring Kelly Rowland","Dirty DianaMichael Jackson","Disco Duck (Part I)Rick Dees & His Cast Of Idiots","Disco LadyJohnnie Taylor","DisturbiaRihanna","DizzyTommy Roe",
"Do I Make You ProudTaylor Hicks","Do That To Me One More TimeCaptain & Tennille","Do Wah Diddy DiddyManfred Mann","Doesnt Really MatterJanet","DominiqueThe Singing Nun (Soeur Sourire)","Dont Break The Heart That Loves YouConnie Francis",
"Dont Forget About UsMariah Carey","Dont Give Up On UsDavid Soul","Dont Go Breaking My HeartElton John & Kiki Dee","Dont Leave Me This WayThelma Houston","Dont Let The Sun Go Down On MeGeorge Michael/Elton John","Dont MatterAkon",
"Dont Stop til You Get EnoughMichael Jackson","Dont Wanna Lose YouGloria Estefan","Dont Worry, Be Happy (From Cocktail)Bobby McFerrin","Dont You (Forget About Me)Simple Minds","Dont You Want MeThe Human League","Doo Wop (That Thing)Lauryn Hill",
"Down UnderMen At Work","DownJay Sean Featuring Lil Wayne","DowntownPetula Clark","DreamloverMariah Carey","DreamsFleetwood Mac","Drop It Like Its HotSnoop Dogg Featuring Pharrell","Duke Of EarlGene Chandler","DynamiteBTS",
"E.T.Katy Perry Featuring Kanye West","Easier Said Than DoneThe Essex","Ebony And IvoryPaul McCartney And Stevie Wonder","Eight Days A WeekThe Beatles","El PasoMarty Robbins","EmotionsMariah Carey","Empire State Of MindJay-Z + Alicia Keys",
"End Of The Road (From Boomerang)Boyz II Men","Endless LoveDiana Ross & Lionel Richie","EscapadeJanet Jackson","Escape (The Pina Colada Song)Rupert Holmes","Eternal FlameThe Bangles","Eve Of DestructionBarry McGuire",
"Evergreen (Love Theme From A Star Is Born)Barbra Streisand","Every Breath You TakeThe Police","Every Rose Has Its ThornPoison","Everybody Loves SomebodyDean Martin","Everybody Wants To Rule The WorldTears For Fears","Everybodys Somebodys FoolConnie Francis",
"Everyday PeopleSly & The Family Stone","Everything Is BeautifulRay Stevens","Everything She WantsWham!","Everything You WantVertical Horizon","Everytime You Go AwayPaul Young","Exhale (Shoop Shoop) (From Waiting To Exhale)Whitney Houston",
"Eye Of The TigerSurvivor","FaithGeorge Michael","Fallin In LoveHamilton, Joe Frank & Reynolds","FallinAlicia Keys","FameDavid Bowie","Family AffairMary J. Blige","Family AffairSly & The Family Stone","FancyIggy Azalea Featuring Charli XCX",
"FantasyMariah Carey","Father FigureGeorge Michael","Feel Like Makin LoveRoberta Flack","Fingertips - Pt 2Little Stevie Wonder","FireOhio Players","FirefliesOwl City","FireworkKaty Perry","Flashdance...What A FeelingIrene Cara",
"Fly, Robin, FlySilver Convention","Foolish BeatDebbie Gibson","FoolishAshanti","FootlooseKenny Loggins","Forever Your GirlPaula Abdul","FranchiseTravis Scott Featuring Young Thug & M.I.A.","FrankensteinEdgar Winter Group","Freak MeSilk","FunkytownLipps, Inc.",
"Game Of LoveWayne Fontana & The Mindbenders","Gangstas Paradise (From Dangerous Minds)Coolio Featuring L.V.","Genie In A BottleChristina Aguilera","Georgia On My MindRay Charles","Get BackThe Beatles With Billy Preston","Get BusySean Paul",
"Get Down TonightKC And The Sunshine Band","Get Off Of My CloudThe Rolling Stones","Get Outta My Dreams, Get Into My CarBilly Ocean","Gettin Jiggy Wit ItWill Smith","GhostbustersRay Parker Jr.","Girl Im Gonna Miss YouMilli Vanilli",
"GirlfriendAvril Lavigne","Girls Like YouMaroon 5 Featuring Cardi B","Give It To MeTimbaland Featuring Nelly Furtado & Justin Timberlake","Give Me EverythingPitbull Featuring Ne-Yo, Afrojack & Nayer","Give Me Love - (Give Me Peace On Earth)George Harrison",
"GlamorousFergie Featuring Ludacris","Glory Of Love (Theme From The Karate Kid Part II)Peter Cetera","Go Away Little GirlDonny Osmond","Go Away Little GirlSteve Lawrence","Gods PlanDrake","Gold DiggerKanye West Featuring Jamie Foxx",
"Gonna Fly NowBill Conti","Gonna Make You Sweat (Everybody Dance Now)C+C Music Factory","Good LovinThe Young Rascals","Good Luck CharmElvis Presley With The Jordanaires","Good ThingFine Young Cannibals","Good TimesChic",
"Good VibrationsMarky Mark & The Funky Bunch Featuring Loleatta Holloway","Good VibrationsThe Beach Boys","GoodiesCiara Featuring Petey Pablo","Got My Mind Set On YouGeorge Harrison","Got To Give It Up (Pt. I)Marvin Gaye","Grazing In The GrassHugh Masekela",
"GreaseFrankie Valli","Greatest Love Of AllWhitney Houston","Green TambourineThe Lemon Pipers","GrenadeBruno Mars","GrillzNelly Featuring Paul Wall, Ali & Gipp","GroovinThe Young Rascals","Groovy Kind Of LovePhil Collins","Gypsys, Tramps & ThievesCher",
"HIGHEST IN THE ROOMTravis Scott","Half-BreedCher","Hang On SloopyThe McCoys","Hangin ToughNew Kids On The Block","Hanky PankyTommy James And The Shondells","Happy TogetherThe Turtles","HappyPharrell Williams","Hard To Say Im SorryChicago",
"Harlem ShakeBaauer","Harper Valley P.T.A.Jeannie C. Riley","HavanaCamila Cabello Featuring Young Thug","Have You Ever Really Loved A Woman?Bryan Adams","Have You Ever?Brandy","Have You Never Been MellowOlivia Newton-John",
"He Dont Love You (Like I Love You)Tony Orlando & Dawn","Head To ToeLisa Lisa And Cult Jam","Heart Of GlassBlondie","Heart Of GoldNeil Young","Heartache TonightEagles","Heartaches By The NumberGuy Mitchell","HeartbreakerMariah Carey Featuring Jay-Z",
"HeartlessThe Weeknd","Heaven Is A Place On EarthBelinda Carlisle","HeavenBryan Adams","Hello GoodbyeThe Beatles","Hello, Dolly!Louis Armstrong And The All Stars","Hello, I Love YouThe Doors","HelloAdele","HelloLionel Richie","Help Me, RhondaThe Beach Boys",
"Help!The Beatles","Here Comes The Hotstepper (From Ready To Wear)Ini Kamoze","Here I Go AgainWhitesnake","HeroMariah Carey","Hes A RebelThe Crystals","Hes So FineThe Chiffons","Hey JudeThe Beatles","Hey PaulaPaul and Paula","Hey There DelilahPlain White Ts",
"Hey Ya!OutKast","Hey! BabyBruce Channel","Higher LoveSteve Winwood","Hips Dont LieShakira Featuring Wyclef Jean","Hit The Road JackRay Charles and his Orchestra","Hold It Against MeBritney Spears","Hold On To The NightsRichard Marx",
"Hold OnWilson Phillips","Holding Back The YearsSimply Red","Hollaback GirlGwen Stefani","HoneyBobby Goldsboro","HoneyMariah Carey","Honky Tonk WomenThe Rolling Stones","Hooked On A FeelingBlue Swede","Hot Child In The CityNick Gilder",
"Hot In HerreNelly","Hot StuffDonna Summer","Hotel CaliforniaEagles","House Of The Rising SunThe Animals","How Am I Supposed To Live Without YouMichael Bolton","How Can You Mend A Broken HeartBee Gees","How Deep Is Your LoveBee Gees",
"How Do U Want It/California Love2Pac Featuring K-Ci And JoJo","How Do You Talk To An AngelThe Heights","How Will I KnowWhitney Houston","How You Remind MeNickelback","HumanThe Human League","Humble.Kendrick Lamar","HypnotizeThe Notorious B.I.G.",
"I Adore Mi AmorColor Me Badd","I Am WomanHelen Reddy","I BelieveFantasia","I Can HelpBilly Swan","I Can See Clearly NowJohnny Nash","I Cant Get Next To YouThe Temptations","I Cant Go For That (No Can Do)Daryl Hall John Oates",
"I Cant Help Myself (Sugar Pie Honey Bunch)Four Tops","I Cant Stop Loving YouRay Charles","I Dont Have The HeartJames Ingram","I Dont Wanna CryMariah Carey","I Dont Want To Miss A ThingAerosmith","I Feel FineThe Beatles","I Get AroundThe Beach Boys",
"I Got You BabeSonny & Cher","I Gotta FeelingThe Black Eyed Peas","I Hear A SymphonyThe Supremes","I Heard It Through The GrapevineMarvin Gaye","I Honestly Love YouOlivia Newton-John","I Just Called To Say I Love YouStevie Wonder",
"I Just Cant Stop Loving YouMichael Jackson With Siedah Garrett","I Just Want To Be Your EverythingAndy Gibb","I Kissed A GirlKaty Perry","I Knew I Loved YouSavage Garden","I Knew You Were Waiting (For Me)Aretha Franklin & George Michael",
"I Like ItCardi B, Bad Bunny & J Balvin","I Like The Way (The Kissing Game)Hi-Five","I Love A Rainy NightEddie Rabbitt","I Love Rock N RollJoan Jett & the Blackhearts","I Shot The SheriffEric Clapton","I Still Havent Found What Im Looking ForU2",
"I SwearAll-4-One","I Think I Love YouThe Partridge Family Starring Shirley Jones Featuring David Cassidy","I Think Were Alone NowTiffany","I Wanna Dance With Somebody (Who Loves Me)Whitney Houston","I Wanna Love YouAkon Featuring Snoop Dogg",
"I Want To Be WantedBrenda Lee","I Want To Hold Your HandThe Beatles","I Want To Know What Love IsForeigner","I Want You BackJackson 5","I Will Always Love YouWhitney Houston","I Will Follow HimLittle Peggy March","I Will SurviveGloria Gaynor",
"I WishStevie Wonder","I Write The SongsBarry Manilow","Ice Ice BabyVanilla Ice","Id Do Anything For Love (But I Wont Do That)Meat Loaf","If I Cant Have YouYvonne Elliman","If Wishes Came TrueSweet Sensation","If You Dont Know Me By NowSimply Red",
"If You Had My LoveJennifer Lopez","If You Leave Me NowChicago","If You Wanna Be HappyJimmy Soul","Ill Be Loving You (Forever)New Kids On The Block","Ill Be Missing YouPuff Daddy & Faith Evans Featuring 112","Ill Be There For YouBon Jovi",
"Ill Be ThereJackson 5","Ill Be ThereMariah Carey","Ill Be Your EverythingTommy Page","Ill Make Love To YouBoyz II Men","Ill Take You ThereThe Staple Singers","Im A BelieverThe Monkees","Im Henry VIII, I AmHermans Hermits",
"Im Leaving It Up To YouDale & Grace","Im RealJennifer Lopez Featuring Ja Rule","Im SorryBrenda Lee","Im SorryJohn Denver","Im Telling You NowFreddie And The Dreamers","Im The OneDJ Khaled Featuring Justin Bieber, Quavo, Chance The Rapper & Lil Wayne",
"Im Too SexyRight Said Fred","Im Your AngelR. Kelly & Celine Dion","Im Your Baby TonightWhitney Houston","Im Your Boogie ManKC And The Sunshine Band","Imma BeThe Black Eyed Peas","In Da Club50 Cent","In My FeelingsDrake","In The Year 2525Zager & Evans",
"Incense And PeppermintsStrawberry Alarm Clock","IncompleteSisqo","Independent Women Part IDestinys Child","Indian Reservation (The Lament Of The Cherokee Reservation Indian)The Raiders","InformerSnow","Inside Your HeavenCarrie Underwood",
"Invisible TouchGenesis","IrreplaceableBeyonce","Island GirlElton John","Islands In The StreamKenny Rogers Duet With Dolly Parton","It Must Have Been Love (From Pretty Woman)Roxette","It Wasnt MeShaggy Featuring Ricardo RikRok Ducent",
"Its All In The GameTommy Edwards","Its Gonna Be MeN Sync","Its My PartyLesley Gore","Its Now Or NeverElvis Presley With The Jordanaires","Its Only Make BelieveConway Twitty","Its Still Rock And Roll To MeBilly Joel",
"Its Too Late/I Feel The Earth MoveCarole King","Itsy Bitsy Teenie Weenie Yellow Polkadot BikiniBrian Hyland","Ive Been Thinking About YouLondonbeat","Jack & DianeJohn Cougar","Jacobs LadderHuey Lewis & The News",
"Jessies GirlRick Springfield","Jive TalkinBee Gees","Johnny AngelShelley Fabares","Joy To The WorldThree Dog Night","JoyrideRoxette","Judy In Disguise (With Glasses)John Fred And The Playboys","JumpKris Kross","JumpVan Halen",
"Just DanceLady Gaga Featuring Colby ODonis","Just Give Me A ReasonP!nk Featuring Nate Ruess","Just My Imagination (Running Away With Me)The Temptations","Just The Way You AreBruno Mars","Justify My LoveMadonna","Kansas CityWilbert Harrison",
"Karma ChameleonCulture Club","Keep On Loving YouREO Speedwagon","Keep On Truckin (Part 1)Eddie Kendricks","Killing Me Softly With His SongRoberta Flack","Kind Of A DragThe Buckinghams","Kiss And Say GoodbyeThe Manhattans","Kiss From A RoseSeal",
"Kiss KissChris Brown Featuring T-Pain","Kiss On My ListDaryl Hall John Oates","Kiss You All OverExile","KissPrince And The Revolution","Knock On WoodAmii Stewart","Knock Three TimesDawn","Kokomo (FromCocktail )The Beach Boys",
"Kung Fu FightingCarl Douglas","KyrieMr. Mister","La BambaLos Lobos","Lady MarmaladeChristina Aguilera, Lil Kim, Mya & P!nk","Lady MarmaladeLabelle","LadyKenny Rogers","Laffy TaffyD4L","Last Friday Night (T.G.I.F.)Katy Perry",
"Last Train To ClarksvilleThe Monkees","LatelyDivine","Laughter In The RainNeil Sedaka","Le FreakChic","Leader Of The PackThe Shangri-Las","Lean BackTerror Squad","Lean On MeBill Withers","Lean On MeClub Nouveau","Leaving On A Jet PlanePeter, Paul & Mary",
"Let It BeThe Beatles","Let Me Love YouMario","Let Your Love FlowBellamy Brothers","Lets DanceDavid Bowie","Lets Do It AgainThe Staple Singers","Lets Get It OnMarvin Gaye","Lets Go CrazyPrince And The Revolution","Lets Hear It For The BoyDeniece Williams",
"Lets Stay TogetherAl Green","Life Goes OnBTS","Light My FireThe Doors","Lightnin StrikesLou Christie","Like A G6Far*East Movement Featuring Cataracs & Dev","Like A PrayerMadonna","Like A VirginMadonna","Listen To What The Man SaidWings",
"Listen To Your HeartRoxette","Little StarThe Elegants","Live To TellMadonna","Live Your LifeT.I. Featuring Rihanna","Livin La Vida LocaRicky Martin","Livin On A PrayerBon Jovi","Locked Out Of HeavenBruno Mars","LollipopLil Wayne Featuring Static Major",
"London BridgeFergie","Lonely BoyPaul Anka","Look AwayChicago","Look What You Made Me DoTaylor Swift","Looks Like We Made ItBarry Manilow","Lose You To Love MeSelena Gomez","Lose YourselfEminem","Lost In EmotionLisa Lisa And Cult Jam",
"Lost In Your EyesDebbie Gibson","Love BitesDef Leppard","Love ChildDiana Ross & The Supremes","Love HangoverDiana Ross","Love In This ClubUsher Featuring Young Jeezy","Love Is Blue (Lamour Est Bleu)Paul Mauriat And His Orchestra",
"Love Is Here And Now Youre GoneThe Supremes","Love Machine (Part 1)The Miracles","Love Me DoThe Beatles","Love RollercoasterOhio Players","Love Takes TimeMariah Carey","Love The Way You LieEminem Featuring Rihanna",
"Love Theme From Romeo & JulietHenry Mancini And His Orchestra","Love TrainThe OJays","Love Will Keep Us TogetherCaptain & Tennille","Love Will Lead You BackTaylor Dayne","Love Will Never Do (Without You)Janet Jackson",
"Love You Inside OutBee Gees","Love YourselfJustin Bieber","Loves ThemeLove Unlimited Orchestra","Lovin YouMinnie Riperton","LowFlo Rida Featuring T-Pain","Lucy In The Sky With DiamondsElton John","MMMBopHanson","MacArthur ParkDonna Summer",
"Macarena (Bayside Boys Mix)Los Del Rio","Mack The KnifeBobby Darin","Maggie May/Reason To BelieveRod Stewart","MagicOlivia Newton-John","Make It With YouBread","Makes Me WonderMaroon 5","Mama Told Me (Not To Come)Three Dog Night",
"Man In The MirrorMichael Jackson","MandyBarry Manilow","ManeaterDaryl Hall John Oates","ManiacMichael Sembello","Maria MariaSantana Featuring The Product G&B","Me And Bobby McGeeJanis Joplin","Me And Mrs. JonesBilly Paul","MedleyStars On 45",
"Miami Vice ThemeJan Hammer","MichaelThe Highwaymen","MickeyToni Basil","Midnight Train To GeorgiaGladys Knight And The Pips","Miss You MuchJanet Jackson","Miss YouThe Rolling Stones","Missing YouJohn Waite",
"Mo Money Mo ProblemsThe Notorious B.I.G. Featuring Puff Daddy & Mase","Monday, MondayThe Mamas & The Papas","Money For NothingDire Straits","Money MakerLudacris Featuring Pharrell","MonkeyGeorge Michael",
"Monster MashBobby Boris Pickett And The Crypt-Kickers","Mony MonyBilly Idol","Mood24kGoldn Featuring iann dior","Moody RiverPat Boone","More Than WordsExtreme","Morning Train (Nine To Five)Sheena Easton","Mother-In-LawErnie K-Doe",
"Moves Like JaggerMaroon 5 Featuring Christina Aguilera","Mr. BlueThe Fleetwoods","Mr. CusterLarry Verne","Mr. LonelyBobby Vinton","Mr. Tambourine ManThe Byrds","Mrs. Brown Youve Got A Lovely DaughterHermans Hermits","Mrs. RobinsonSimon & Garfunkel",
"Ms. JacksonOutKast","MusicMadonna","My AllMariah Carey","My BooUsher And Alicia Keys","My Boyfriends BackThe Angels","My Ding-A-LingChuck Berry","My Eyes Adored YouFrankie Valli","My GirlThe Temptations","My GuyMary Wells",
"My Heart Has A Mind Of Its OwnConnie Francis","My Heart Will Go OnCeline Dion","My Life Would Suck Without YouKelly Clarkson","My LoveJustin Timberlake Featuring T.I.","My LovePaul McCartney And Wings","My LovePetula Clark","My PrerogativeBobby Brown",
"My SharonaThe Knack","My Sweet Lord/Isnt It A PityGeorge Harrison","Na Na Hey Hey Kiss Him GoodbyeSteam","Need You TonightINXS","Nel Blu Dipinto Di Blu (Volaré)Domenico Modugno","Never Gonna Give You UpRick Astley",
"New Kid In TownEagles","Nice & SlowUsher","Nice For WhatDrake","Night FeverBee Gees","No DiggityBLACKstreet (Featuring Dr. Dre)","No More Tears (Enough Is Enough)Barbra Streisand/Donna Summer","No OneAlicia Keys","No ScrubsTLC",
"Not AfraidEminem","Nothin On YouB.o.B Featuring Bruno Mars","Nothing Compares 2 USinead OConnor","Nothing From NothingBilly Preston","Nothings Gonna Stop Us NowStarship","OMGUsher Featuring will.i.am","Ode To Billie JoeBobbie Gentry",
"Oh GirlThe Chi-lites","Oh SheilaReady For The World","Oh, Pretty WomanRoy Orbison And The Candy Men","Old Town RoadLil Nas X Featuring Billy Ray Cyrus","On Bended KneeBoyz II Men","On My OwnPatti LaBelle & Michael McDonald","One Bad AppleThe Osmonds",
"One DanceDrake Featuring WizKid & Kyla","One More NightMaroon 5","One More NightPhil Collins","One More TryGeorge Michael","One More TryTimmy T.","One Of These NightsEagles","One Sweet DayMariah Carey & Boyz II Men","One WeekBarenaked Ladies",
"Only Girl (In The World)Rihanna","Open Your HeartMadonna","Opposites AttractPaula Abdul (Duet With The Wild Pair)","Our Day Will ComeRuby And The Romantics","Out Of TouchDaryl Hall John Oates","Over And OverThe Dave Clark Five",
"Owner Of A Lonely HeartYes","Paint It, BlackThe Rolling Stones","PandaDesiigner","Papa Dont PreachMadonna","Papa Was A Rollin StoneThe Temptations","Paperback WriterThe Beatles","Part Of MeKaty Perry","Part-Time LoverStevie Wonder",
"Party Rock AnthemLMFAO Featuring Lauren Bennett & GoonRock","Penny LaneThe Beatles","People Got To Be FreeThe Rascals","Peppermint Twist - Part IJoey Dee & the Starliters","PerfectEd Sheeran","Philadelphia FreedomThe Elton John Band",
"PhotographRingo Starr","PhysicalOlivia Newton-John","Pick Up The PiecesAWB","PillowtalkZayn","Play That Funky MusicWild Cherry","Please Dont GoKC And The Sunshine Band","Please Mr. PostmanCarpenters","Please Mr. PostmanThe Marvelettes",
"Poker FaceLady Gaga","Pony TimeChubby Checker","Poor Little FoolRicky Nelson","Poor Side Of TownJohnny Rivers","Pop MuzikM","PositionsAriana Grande","Praying For TimeGeorge Michael","Private EyesDaryl Hall John Oates",
"PromiscuousNelly Furtado Featuring Timbaland","PsychoPost Malone Featuring Ty Dolla $ign","Quarter To ThreeU.S. Bonds","Rag DollThe 4 Seasons Featuring the Sound of Frankie Valli","Rain On MeLady Gaga & Ariana Grande",
"Raindrops Keep Fallin On My HeadB.J. Thomas","Raise Your GlassP!nk","RaptureBlondie","Reach Out Ill Be ThereFour Tops","Red Red WineUB40","Release MeWilson Phillips","RespectAretha Franklin","ReunitedPeaches & Herb","Rhinestone CowboyGlen Campbell",
"Rich GirlDaryl Hall John Oates","RidinChamillionaire Featuring Krayzie Bone","Right Here WaitingRichard Marx","Right RoundFlo Rida","Ring My BellAnita Ward","RingoLorne Greene","RiseHerb Alpert","RoarKaty Perry","Rock Me AmadeusFalco",
"Rock Me GentlyAndy Kim","Rock On (From Dream A Little Dream)Michael Damian","Rock The BoatThe Hues Corporation","Rock With YouMichael Jackson","Rock Your BabyGeorge McCrae","Rockn MeSteve Miller","RockstarDaBaby Featuring Roddy Ricch",
"RockstarPost Malone Featuring 21 Savage","Roll With ItSteve Winwood","Rolling In The DeepAdele","RomanticKaryn White","Roses Are Red (My Love)Bobby Vinton","RoyalsLorde","Ruby TuesdayThe Rolling Stones","Rude BoyRihanna","RudeMAGIC!",
"Run It!Chris Brown","Runaround SueDion","RunawayDel Shannon","Running BearJohnny Preston","Running ScaredRoy Orbison","Rush RushPaula Abdul","S&MRihanna Featuring Britney Spears","SOSRihanna","Sad EyesRobert John","Sad!XXXTENTACION",
"SailingChristopher Cross","SaraStarship","SatisfiedRichard Marx","Saturday NightBay City Rollers","Savage Love (Laxed - Siren Beat)Jawsh 685 x Jason Derulo","SavageMegan Thee Stallion","Save The Best For LastVanessa Williams",
"Save The Last Dance For MeThe Drifters","Saving All My Love For YouWhitney Houston","Say It RightNelly Furtado","Say My NameDestinys Child","Say Say SayPaul McCartney And Michael Jackson","Say SoDoja Cat Featuring Nicki Minaj",
"Say You, Say MeLionel Richie","Seasons ChangeExpose","Seasons In The SunTerry Jacks","See You AgainWiz Khalifa Featuring Charlie Puth","SenoritaShawn Mendes & Camila Cabello","Separate LivesPhil Collins and Marilyn Martin",
"Set Adrift On Memory BlissP.M. Dawn","Set Fire To The RainAdele","Sexy And I Know ItLMFAO","SexyBackJustin Timberlake","Shadow DancingAndy Gibb","Shake It OffTaylor Swift","Shake Ya TailfeatherNelly, P. Diddy & Murphy Lee",
"Shake You DownGregory Abbott","Shakedown (From Beverly Hills Cop II)Bob Seger","ShallowLady Gaga & Bradley Cooper","Shape Of YouEd Sheeran","She Aint Worth ItGlenn Medeiros Featuring Bobby Brown","She Drives Me CrazyFine Young Cannibals",
"She Loves YouThe Beatles","SheilaTommy Roe","SherryThe 4 Seasons","Shining StarEarth, Wind & Fire","ShoutTears For Fears","Show And TellAl Wilson","Sicko ModeTravis Scott","Silly Love SongsWings","Single Ladies (Put A Ring On It)Beyonce",
"Sir DukeStevie Wonder","Sister Golden HairAmerica","SledgehammerPeter Gabriel","Sleep WalkSanto & Johnny","Slow JamzTwista Featuring Kanye West & Jamie Foxx","Slow MotionJuvenile Featuring Soulja Slim","Smoke Gets In Your EyesThe Platters",
"SmoothSantana Featuring Rob Thomas","So EmotionalWhitney Houston","So Much In LoveThe Tymes","So SickNe-Yo","So WhatP!nk","Soldier BoyThe Shirelles","Somebody That I Used To KnowGotye Featuring Kimbra","Someday Well Be TogetherDiana Ross & The Supremes",
"SomedayMariah Carey","Someone Like YouAdele","Someone You LovedLewis Capaldi","Somethin StupidNancy Sinatra & Frank Sinatra","Song Sung BlueNeil Diamond","SorryJustin Bieber","Southern NightsGlen Campbell","St. Elmos Fire (Man In Motion)John Parr",
"Stagger LeeLloyd Price","Stand UpLudacris Featuring Shawnna","Star Wars Theme/Cantina BandMeco","StarboyThe Weeknd Featuring Daft Punk","Stay (I Missed You) (From Reality Bites)Lisa Loeb & Nine Stories","StayMaurice Williams & The Zodiacs",
"Stayin AliveBee Gees","Step By StepNew Kids On The Block","StillCommodores","Stop! In The Name Of LoveThe Supremes","Straight UpPaula Abdul","Stranger On The ShoreMr. Acker Bilk","Strangers In The NightFrank Sinatra",
"Stronger (What Doesnt Kill You)Kelly Clarkson","StrongerKanye West","Stuck On YouElvis Presley With The Jordanaires","Stuck With UAriana Grande & Justin Bieber","Stuck With YouHuey Lewis & The News","StutterJoe Featuring Mystikal","SuckerJonas Brothers",
"Sugar ShackJimmy Gilmer And The Fireballs","Sugar, SugarThe Archies","SukiyakiKyu Sakamoto","Summer In The CityThe Lovin Spoonful","SundownGordon Lightfoot","Sunflower (Spider-Man: Into The Spider-Verse)Post Malone & Swae Lee",
"Sunshine On My ShouldersJohn Denver","Sunshine SupermanDonovan","SuperstitionStevie Wonder","Surf CityJan & Dean","SurrenderElvis Presley With The Jordanaires","Suspicious MindsElvis Presley","SussudioPhil Collins","Sweet Child O MineGuns N Roses",
"Sweet Dreams (Are Made Of This)Eurythmics","TSOP (The Sound Of Philadelphia)MFSB Featuring The Three Degrees","Take A BowMadonna","Take A BowRihanna","Take Good Care Of My BabyBobby Vee","Take My Breath Away (Love Theme From Top Gun)Berlin",
"Take On Mea-ha","Teen AngelMark Dinning","Teenage DreamKaty Perry","Tell Her About ItBilly Joel","TelstarThe Tornadoes","TemperatureSean Paul","Tha CrossroadsBone Thugs-N-Harmony","Thank God I Found YouMariah Carey Featuring Joe & 98 Degrees",
"Thank God Im A Country BoyJohn Denver","Thank U, NextAriana Grande","Thank You Falettinme Be Mice Elf Agin/Everybody Is A StarSly & The Family Stone","Thats The Way (I Like It)KC And The Sunshine Band","Thats The Way Love GoesJanet Jackson",
"Thats What Friends Are ForDionne & Friends","Thats What I LikeBruno Mars","The Ballad Of The Green BeretsSSgt Barry Sadler","The Battle Of New OrleansJohnny Horton","The BoxRoddy Ricch","The Boy Is MineBrandy & Monica",
"The Candy ManSammy Davis, Jr. with The Mike Curb Congregation","The Chipmunk SongThe Chipmunks With David Seville","The First NightMonica","The First Time Ever I Saw Your FaceRoberta Flack","The First TimeSurface","The FlameCheap Trick",
"The HappeningThe Supremes","The Happy OrganDave Baby Cortez","The HillsThe Weeknd","The HustleVan McCoy And The Soul City Symphony","The JokerThe Steve Miller Band","The LetterThe Box Tops","The Lion Sleeps TonightThe Tokens",
"The Living YearsMike + The Mechanics","The Loco-MotionGrand Funk","The Loco-MotionLittle Eva","The Long And Winding Road/For You BlueThe Beatles","The LookRoxette","The Love You Save/I Found That GirlJackson 5","The MonsterEminem Featuring Rihanna",
"The Morning AfterMaureen McGovern","The Most Beautiful GirlCharlie Rich","The Next Time I FallPeter Cetera With Amy Grant","The Night Chicago DiedPaper Lace","The Night The Lights Went Out In GeorgiaVicki Lawrence","The One That You LoveAir Supply",
"The Power Of LoveCeline Dion","The Power Of LoveHuey Lewis & The News","The Promise Of A New DayPaula Abdul","The ReflexDuran Duran","The ScottsTHE SCOTTS, Travis Scott & Kid Cudi","The SignAce Of Base","The Sound Of SilenceSimon & Garfunkel",
"The StreakRay Stevens","The StripperDavid Rose and His Orchestra","The Tears Of A ClownSmokey Robinson & The Miracles","The Theme From A Summer PlacePercy Faith And His Orchestra","The Three BellsThe Browns","The Tide Is HighBlondie",
"The TwistChubby Checker","The Way It IsBruce Hornsby & The Range","The Way We WereBarbra Streisand","The Way You Make Me FeelMichael Jackson","The Way You MoveOutKast Featuring Sleepy Brown",
"Theme From Mahogany (Do You Know Where Youre Going To)Diana Ross","Theme From S.W.A.T.Rhythm Heritage","Theme From ShaftIsaac Hayes","Then Came YouDionne Warwicke & Spinners",
"There! Ive Said It AgainBobby Vinton","Therell Be Sad Songs (To Make You Cry)Billy Ocean","These Boots Are Made For WalkinNancy Sinatra","These DreamsHeart","This Diamond RingGary Lewis And The Playboys","This Guys In Love With YouHerb Alpert",
"This Is AmericaChildish Gambino","This Is How We Do ItMontell Jordan","This Is The NightClay Aiken","This Is Why Im HotMims","This Used To Be My PlaygroundMadonna","Three Times A LadyCommodores","Thrift ShopMacklemore & Ryan Lewis Featuring Wanz",
"TiK ToKKe$ha","Ticket To RideThe Beatles","Tie A Yellow Ribbon Round The Ole Oak TreeDawn Featuring Tony Orlando","Tighten UpArchie Bell & The Drells","TimberPitbull Featuring Ke$ha","Time After TimeCyndi Lauper",
"Time In A BottleJim Croce","To Be With YouMr. Big","To Know Him, Is To Love HimThe Teddy Bears","To Sir With LoveLulu","Together AgainJanet","Together ForeverRick Astley","Tom DooleyThe Kingston Trio",
"Tonights The Night (Gonna Be Alright)Rod Stewart","Too CloseNext","Too Much HeavenBee Gees","Too Much, Too Little, Too LateJohnny Mathis/Deniece Williams","Toosie SlideDrake","Top Of The WorldCarpenters","Torn Between Two LoversMary Macgregor",
"Tossin And TurninBobby Lewis","Total Eclipse Of The HeartBonnie Tyler","Touch Me In The MorningDiana Ross","Touch My BodyMariah Carey","Toy SoldiersMartika","TragedyBee Gees","Travelin ManRicky Nelson",
"Trollz6ix9ine & Nicki Minaj","True ColorsCyndi Lauper","Truly Madly DeeplySavage Garden","TrulyLionel Richie","Truth HurtsLizzo","Try AgainAaliyah","Turn! Turn! Turn! (To Everything There Is A Season)The Byrds","Two HeartsPhil Collins",
"U Got It BadUsher","U Remind MeUsher","UmbrellaRihanna Featuring Jay-Z","Un-Break My HeartToni Braxton","UnbelievableEMF","Uncle Albert/Admiral HalseyPaul & Linda McCartney","Undercover AngelAlan ODay","UnprettyTLC",
"Up Where We BelongJoe Cocker And Jennifer Warnes","Upside DownDiana Ross","Uptown Funk!Mark Ronson Featuring Bruno Mars","VenusBananarama","VenusFrankie Avalon","VenusThe Shocking Blue","Vision Of LoveMariah Carey","Viva La VidaColdplay",
"VogueMadonna","WAPCardi B Featuring Megan Thee Stallion","Wake Me Up Before You Go-GoWham!","Walk Like A ManThe 4 Seasons","Walk Like An EgyptianThe Bangles","Walk Right InThe Rooftop Singers","WannabeSpice Girls","Want AdsThe Honey Cone",
"WarEdwin Starr","WaterfallsTLC","Watermelon SugarHarry Styles","We Are Never Ever Getting Back TogetherTaylor Swift","We Are The WorldUSA For Africa","We Are Youngfun. Featuring Janelle Monae","We Belong TogetherMariah Carey",
"We Built This CityStarship","We Can Work It OutThe Beatles","We Didnt Start The FireBilly Joel","We Found LoveRihanna Featuring Calvin Harris","We R Who We RKe$ha","WeakSWV","Wedding Bell BluesThe 5th Dimension","Welcome BackJohn Sebastian",
"Were An American BandGrand Funk","West End GirlsPet Shop Boys","What A Fool BelievesThe Doobie Brothers","What A Girl WantsChristina Aguilera","What Do You Mean?Justin Bieber","What Goes Around...Comes AroundJustin Timberlake","Whatcha SayJason Derulo",
"Whatever Gets You Thru The NightJohn Lennon With The Plastic Ono Nuclear Band","Whatever You LikeT.I.","Whats Love Got To Do With ItTina Turner","Whats My Name?Rihanna Featuring Drake","When A Man Loves A WomanMichael Bolton",
"When A Man Loves A WomanPercy Sledge","When Doves CryPrince","When I Need YouLeo Sayer","When I See You SmileBad English","When I Think Of YouJanet Jackson","When I Was Your ManBruno Mars","When Im With YouSheriff",
"Where Did Our Love GoThe Supremes","Where Do Broken Hearts GoWhitney Houston","WhistleFlo Rida","Who Can It Be Now?Men At Work","Whos That GirlMadonna","WhyFrankie Avalon","Wild ThingThe Troggs","Wild Wild WestWill Smith Featuring Dru Hill & Kool Mo Dee",
"Wild, Wild WestThe Escape Club","Will It Go Round In CirclesBilly Preston","Will You Love Me TomorrowThe Shirelles","WillowTaylor Swift","Winchester CathedralThe New Vaudeville Band","Wind Beneath My Wings (From Beaches)Bette Midler",
"WindyThe Association","Wishing WellTerence Trent DArby","With A Little LuckWings","With Arms Wide OpenCreed","With or Without YouU2","Without MeHalsey","Without YouNilsson","Woman In LoveBarbra Streisand","WomanizerBritney Spears",
"Wonderland By NightBert Kaempfert And His Orchestra","Wooden HeartJoe Dowell","WorkRihanna Featuring Drake","Wrecking BallMiley Cyrus","Yeah!Usher Featuring Lil Jon & Ludacris","YesterdayThe Beatles",
"You Aint Seen Nothing Yet/Free WheelinBachman-Turner Overdrive","You Are Not AloneMichael Jackson","You Are The Sunshine Of My LifeStevie Wonder","You Cant Hurry LoveThe Supremes","You Dont Bring Me FlowersBarbra Streisand & Neil Diamond",
"You Dont Have To Be A Star (To Be In My Show)Marilyn McCoo & Billy Davis, Jr.","You Give Love A Bad NameBon Jovi","You Havent Done NothinStevie Wonder","You Keep Me Hangin OnKim Wilde","You Keep Me Hangin OnThe Supremes","You Light Up My LifeDebby Boone",
"You Make Me Feel Like DancingLeo Sayer","You Needed MeAnne Murray","You Should Be DancingBee Gees","Youre BeautifulJames Blunt","Youre In LoveWilson Phillips","Youre Makin Me High/Let It FlowToni Braxton","Youre No GoodLinda Ronstadt",
"Youre SixteenRingo Starr","Youre So VainCarly Simon","Youre The One That I WantJohn Travolta & Olivia Newton-John","Youve Got A FriendJames Taylor","Youve Lost That Lovin FeelinThe Righteous Brothers")
	then hit = 1;
else hit = 0;
run; quit;

proc tabulate data=merged2;
	var weekID;
	tables weekID, (min median max)*f=date9.;
	title 'Min and Max Dates In Cleaned Dataset';
run; quit;

* create a dataset containing only acoustic characteristics, popularity, and hit target variables;
data merged3;
	set merged2 (keep=songID spotify_track_explicit spotify_track_duration_ms
				 spotify_track_popularity danceability energy key loudness 
				 mode speechiness acousticness instrumentalness liveness valence
				 tempo time_signature hit);
run; quit;

proc contents data=merged3 order=varnum;
	ods select position;
	title 'Variables in cleaned dataset';
run; quit;

proc means data=merged3 n nmiss min max std sum;
	title 'Descritpive statistics in cleaned datset';
run; quit;

proc freq data=merged3;
	title 'Count of hits vs. non-hits';
	table hit;
run; quit;

* separate singles and duplicates into separate databases;
proc sort data=merged3 nodupkey dupout=remaining_merged_dups out=unique_merged;
	by songId;
run;

proc sql;
	title 'Verify counts of de-duplicated datasets';
	select 'Originial dataset count: ', count(*)
	from merged3;
			
	select 'Count of duplicate records:', count(*)
	from remaining_merged_dups;
	
	select 'Count of unique records: ', count(*)
	from unique_merged;

* get hit vs. non-hit count on de-duplicated dataset;
proc freq data=unique_merged;
	title 'Count of hits vs. non-hits on the de-duplicated dataset';
	table hit;
run; quit;

* confirm the count of duplicates in the un-duplicated dataset;
proc freq data=unique_merged;
	table songId / out=freqout noprint;
run; quit;

proc freq data=freqout;
	table count;
run; quit;


