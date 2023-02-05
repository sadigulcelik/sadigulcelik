/*
2010 variables: http://api.census.gov/data/2010/sf1/variables.html
 ex: P0010001 (Total population 2010)
 2000 variables: http://api.census.gov/data/2000/sf1/variables.html
 ex: P001001 (Total population 2000)
 */
PrintWriter page;
/*PShape usa;
PShape state;*/
void setup() {
  //String stateabs[]=loadStrings("State_Abbreviations.txt");
  //String abbr[]=splitTokens(stateabs[0], ",\"");
  /////Request the original data, GATHER
  String stateText2010[] = loadStrings("http://api.census.gov/data/2010/sf1?key=e8a63d6bac96233cd5c3cf2de348ed9882285b0a&get=H0030003,NAME&for=state:*"); 
  String stateText2000[] = loadStrings("http://api.census.gov/data/2000/sf1?key=e8a63d6bac96233cd5c3cf2de348ed9882285b0a&get=H003003,NAME&for=state:*"); 
  String states[]=new String[51];
  int statevals[]=new int[51];
  int total2010=0;
  int total2000=0;
  for (int i=1; i<52; i++) {
    String [] data2010 = splitTokens(stateText2010[i], "[],\"");
    String [] data2000 = splitTokens(stateText2000[i], "[],\"");
    int house2010 = int(data2010[0]);   
    int house2000 = int(data2000[0]); 
    total2010+=house2010;
    total2000+=house2000;
  }
  for (int i=1; i<52; i++) {

    String [] data2010 = splitTokens(stateText2010[i], "[],\"");
    String [] data2000 = splitTokens(stateText2000[i], "[],\"");
    String name = data2010[1];  //Alabama
    String nextState;
    String previousState;
    if (i<51) {
      nextState=(splitTokens(stateText2010[i+1], "[],\""))[1];
    } else {
      nextState=(splitTokens(stateText2010[1], "[],\""))[1];
    }
    if (i>1) {
      previousState=(splitTokens(stateText2010[i-1], "[],\""))[1];
    } else {
      previousState=(splitTokens(stateText2010[51], "[],\""))[1];
    }
    int house2010 = int(data2010[0]);   
    int house2000 = int(data2000[0]); 
    statevals[i-1]=round(200*(1.0*house2010-1.0*(house2000))/house2000);
    states[i-1]=name;
    page = createWriter(name+".html"); 

    page.println("<html><head><title>"+name
      +"</title><link rel=\"stylesheet\" type=\"text/css\" href=\"style.css\">"
      +"</head><body><h1>State Analysis</h1><h2>"+"<a href=\"https://en.wikipedia.org/wiki/"+name+"\">"+name+"</a>"+"</h2>");
    page.println("<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class=\"bold\">Did the number of vacant homes in the state of "+name+" increase from 2000 to 2010?</span>");
    if (house2010>house2000) {
      page.println("Yes; the number of vacant homes in "+name+
        " increased from "+nfc(house2000)+" to "+ nfc(house2010) + " by "+
        nfc(house2010-house2000)+"; by "+(100*(1.0*house2010-house2000)/house2000)+"%.");
    } else if (house2000>house2010) {
      page.println("No; the number of vacant homes in "+name+
        " decreased from "+nfc(house2000)+" to "+ nfc(house2010) + " by "+ 
        nfc(house2000-house2010)+"; by "+(100*(1.0*house2000-house2010)/house2000)+"%.");
    } else if (house2000==house2010) {
      page.println("No; the number of vacant homes in "+name+
        "remained the same at "+ nfc(house2000) +" vacant homes");
    }
    page.println("<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
    if (total2010>total2000) {
    page.println("Throughout the entire US, the number of vacant homes increased from "+nfc(total2000)+" to "+ nfc(total2010) + " by "+
      nfc(total2010-total2000)+"; "+(100*(total2010-total2000)/total2000)+"%, yielding a national average increase "+
      "of "+nfc(int((total2010-total2000)/51.0))+" per state ("+nfc(int(total2000/51.0))+" to "+nfc(int(total2010/51.0))+").");
  } else if (total2000>total2010) {
    page.println("Throughout the entire US, the number of vacant homes in the US decreased from "+nfc(total2000)+" to "+ nfc(total2010) + " by "+ 
      nfc(total2000-total2010)+"; "+(100*(total2000-total2010)/total2000)+"%. yielding a national average increase "+
      "of"+nfc(int((total2010-total2000)/51.0))+" per state ("+nfc(int(total2000/51.0))+" to "+nfc(int(total2010/51.0))+").");
  } else if (total2000==total2010) {
    page.println("Throught the entire US, the number of vacant homes remained the same at "+ nfc(total2000) +" vacant homes–"+
    "an average of"+nfc(int(total2000/51.0))+".");
  }
    page.println(" <span class=\"bold\">So, is the change in the number of vacant in the state of "+name+ 
    "g reater than, less than, or equal to the average change per state in the number of vacant homes?</span> ");
    float comptonat=((1*(1+(1*(1.0*abs(house2000-house2010))/house2000))/(1+(1*(1.0*abs(total2000-total2010))/total2000))));
    if (comptonat>1){page.println("Yes; ");}
    if (comptonat==1){page.println("No the percentage change is equal"); }
    if (comptonat<1){page.println("No; ");}
    page.println("the increase in "+name+" is "+comptonat+ " times the national average increase.");
    if (comptonat>1.2){page.println("That means "+name+" is far outstripping the rate of growth of vacant homes in the US.");}
    else if(comptonat>=1.05){page.println("That means "+name+"'s rate of growth for vacant housing is above the US average.");}
    else if(comptonat>0.95&&comptonat<1.05){page.println("The rate of growth for vacant housing in "+name+" is right around the US average.");}
    else if(comptonat>0.8){page.println("In "+name+", the rate of growth for vacant housing is below the US average.");}
    else {page.println("The rate of growth for housing in "+name+" is well below the national average.");}
    page.println("</p>");
    int cw=50;
    int s00=int(1.0*house2000/50000*50);
    int s00x=50;
    int s00w=00;
    
    //if (s00>200;

    int n00=int(1.0*total2000/51/50000*50);
    int n00x=150;
    int n00w=0;

    int s10=int(1.0*house2010/50000*50);
    int s10x=250;
    int s10w=0;

    int n10=int(1.0*total2010/51/50000*50);
    int n10x=350; 
    int n10w=0;

    
    int maxh=250;
    while (s00>maxh) {
      s00-=maxh;
      s00w+=50;
      n00x+=50;
      s10x+=50;
      n10x+=50;
    }
    while (n00>maxh) {
      n00-=maxh;
      n00w+=50;
      s10x+=50;
      n10x+=50;
    }
    while (s10>maxh) {
      s10-=200;
      s10w+=50;
      n10x+=50;
    }
    while (n10>maxh) {
      n10-=200;
      n10w+=50;
    }
    int graphw=n10x+100+n10w;
    page.println("<canvas id=\"charts\" width=\""+graphw+"\" height=\"330\"style=\""+
      "border:3px solid #000000;\"></canvas>"+
      "<script>var canvas = document.getElementById(\"charts\");"+
      "var example = canvas.getContext(\"2d\");"+
      "var exampletext = canvas.getContext(\"2d\");"+
      "var state00 = canvas.getContext(\"2d\");"+
      "var state00text=canvas.getContext(\"2d\");"+
      "var national00=canvas.getContext(\"2d\");"+
      "var national00text=canvas.getContext(\"2d\");"+
      "var state10 = canvas.getContext(\"2d\");"+
      "var state10text=canvas.getContext(\"2d\");"+
      "var national10=canvas.getContext(\"2d\");"+
      "var national10text=canvas.getContext(\"2d\");"+
      "var hstate00 = canvas.getContext(\"2d\");"+
      "var hnational00=canvas.getContext(\"2d\");"+
      "var hstate10 = canvas.getContext(\"2d\");"+
      "var hnational10=canvas.getContext(\"2d\");"+
      "var s00="+s00+";"+
      "var n00="+n00+";"+
      "var s10="+s10+";"+
      "var n10="+n10+";"+
      "var line=canvas.getContext(\"2d\");"+
      "var lineh=canvas.getContext(\"2d\");"+ 
      "state00.fillStyle = \"rgb(255,0,0)\";"+
        "hstate00.fillRect("+s00x+",canvas.height-20-"+maxh+","+s00w+","+maxh+");"+       
        "state00.fillRect("+(s00x+s00w)+",canvas.height-20-s00,"+cw+",s00);"+
      "national00.fillStyle = \"rgb(0,255,0)\";"+
        "hnational00.fillRect("+n00x+",canvas.height-20-"+maxh+","+n00w+","+maxh+");"+
        "national00.fillRect("+(n00x+n00w)+",canvas.height-20-n00,"+cw+",n00);"+
      "state10.fillStyle = \"rgb(100,0,0)\";"+
        "hstate10.fillRect("+s10x+",canvas.height-20-"+maxh+","+s10w+","+maxh+");"+
        "state10.fillRect("+(s10x+s10w)+",canvas.height-20-s10,"+cw+",s10);"+
      "national10.fillStyle = \"rgb(0,100,0)\";"+
        "hnational10.fillRect("+n10x+",canvas.height-20-"+maxh+","+n10w+","+maxh+");"+
        "national10.fillRect("+(n10x+n10w)+",canvas.height-20-n10,"+cw+",n10);"+
      "line.lineWidth=2;line.beginPath();"+
        "for (var x=0; x<canvas.width; x+=50){"+       
        "line.moveTo(x,0);"+
        "line.lineTo(x,canvas.height-20);"+
        "}"+
        "line.strokeStyle=\"black\";"+
        "line.stroke();"+
      "lineh.lineWidth=2;lineh.beginPath();"+
        "for (var y=-40; y<canvas.height; y+=50){"+       
        "lineh.moveTo(0,y);"+
        "lineh.lineTo(canvas.width,y);"+
        "}"+
        "lineh.strokeStyle=\"black\";"+
        "lineh.stroke();"+
      "example.fillStyle = \"rgb(255,0,255)\";"+
      "example.fillRect(20,10,10,50);"+
      "exampletext.font=\"20px Times New Roman\";"+
      "exampletext.fillText(\"->50,000 homes\",40,40);"+
      "state00text.textAlign=\"center\";"+ 
      "state00text.font=\"10px Times New Roman\";"+
      "state00text.fillText(\"state 2000 statistics\","+(s00x+(s00w+50)/2)+",canvas.height-8);"+
      "national00text.font=\"10px Times New Roman\";"+
      "national00text.fillText(\"national 2000 average\","+(n00x+(n00w+50)/2)+",canvas.height-8);"+
      "state10text.font=\"10px Times New Roman\";"+
      "state10text.fillText(\"state 2010 statistics\","+(s10x+(s10w+50)/2)+",canvas.height-8);"+
      "national10text.font=\"10px Times New Roman\";"+
      "national10text.fillText(\"national 2010 average\","+(n10x+(n10w+50)/2)+",canvas.height-8);"+
      "</script>");
    page.println("<br>"+
    "<p style=\"text-align: center;\">more about&nbsp;<a href=\"https://en.wikipedia.org/wiki/"+name+"\">"+name+"</a>"+
    "<br><a href=\""+nextState+".html\">next state</a>&nbsp;("+nextState+")"+
    "<br><a href=\""+previousState+".html\">previous state</a>&nbsp;("+previousState+")");
    page.println("<br><a href=\"index.html\">Home</a></p>");
    page.println("<div style=\"position:absolute; bottom:10; right:10;\"><p style=\"text-align:center;\"><a href=http://api.census.gov/data/2000/sf1/variables.html>2000 data source</a>");
    page.println("<br><a href=http://api.census.gov/data/2010/sf1/variables.html>2010 data source</a><br> the data comes from the decennial US census</p></div>");
    page.println("</body></html>");

    page.flush();
    page.close();
  }
  page=createWriter("index.html");
  page.println("<html><head><title>"+"Home"
    +"</title><link rel=\"stylesheet\" type=\"text/css\" href=\"style.css\">"
    +"</head><body><h1>"+"Home"+"</h1>");
  page.println("<p id=\"headText\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class=\"bold\">How did the number of vacant homes changes in the United States from the year 2000 to the year 2010? "+
  "How did each state's change in the number of vacant homes compare to the overall change in the US?</span> "+
  "In this website, I have attempted to display the increase in the number of vacant homes as a percentage, as represented "+
  "in the map below where the redder the color, the more the increase, and the greener, the less the increase in vacant homes. There is no state in which the "+
  "number of empty homes decreased. In pages for each individual state, I have analyzed the data, comparing each state in depth "+
  "to the overall change in vacant homes throughout the US. But now, let's get to numbers:"+
  "");
  if (total2010>total2000) {
    page.println("The number of vacant homes in the US increased from "+nfc(total2000)+" to "+ nfc(total2010) + " by "+
      nfc(total2010-total2000)+"; "+100*(total2010-total2000)/total2000+"%. That means that the average increase "+
      "per state is "+nfc(int((total2010-total2000)/51.0))+" ("+nfc(int(total2000/51.0))+" to "+nfc(int(total2010/51.0))+").");
  } else if (total2000>total2010) {
    page.println("The number of vacant homes in the US decreased from "+nfc(total2000)+" to "+ nfc(total2010) + " by "+ 
      nfc(total2000-total2010)+"; "+100*(total2000-total2010)/total2000+"%. That means that the average increase "+
      "per state is "+nfc(int((total2010-total2000)/51.0))+" ("+nfc(int(total2000/51.0))+" to "+nfc(int(total2010/51.0))+").");
  } else if (total2000==total2010) {
    page.println("The number of vacant homes in the US remained the same at "+ nfc(total2000) +" vacant homes. That's"+
    "an average of"+nfc(int(total2000/51.0))+".");
  }
  page.println("The source for the data is the <a href=\"http://api.census.gov/data/2000/sf1/variables.html\">2000 US Census</a>"+
  " and the <a href=\"http://api.census.gov/data/2010/sf1/variables.html\">2010 US Census</a>.");
  page.println("</p>");
  page.println("<h3 id=\"state\">&nbsp;</h3><script>function display(x){"+
  "document.getElementById(\"state\").innerHTML ="+ 
  "x.getAttribute(\"href\").slice(0, -5).replace(\"%20\",\"&nbsp;\").replace(\"%20\",\"&nbsp;\");"+
  "document.getElementById(\"abc\").src=x.getAttribute(\"href\").concat(\"#charts\");}"+
  "function clearit(x){    document.getElementById(\"state\").innerHTML"+
  "=\"&nbsp;\";document.getElementById(\"abc\").src=\"\";}    </script>");
  //page.println("<img src=map.png>");
  String mycolor= "#FF0000";
int z=0;
String al="rgb("+(255+-statevals[z])+",0,"+statevals[z]+")";
z++;
 String ak="rgb("+(255+-statevals[z])+",0,"+statevals[z]+")";
z++;
 String az="rgb("+(255+-statevals[z])+",0,"+statevals[z]+")";
z++;
 String ar="rgb("+(255+-statevals[z])+",0,"+statevals[z]+")";
z++;
 String ca="rgb("+(255+-statevals[z])+",0,"+statevals[z]+")";
z++;
 String co="rgb("+(255+-statevals[z])+",0,"+statevals[z]+")";
z++;
 String ct="rgb("+(255+-statevals[z])+",0,"+statevals[z]+")";
z++;
 String dc="rgb("+(255+-statevals[z])+",0,"+statevals[z]+")";
z++;
 String de="rgb("+(255+-statevals[z])+",0,"+statevals[z]+")";
z++;
 String fl="rgb("+(255+-statevals[z])+",0,"+statevals[z]+")";
z++;      
 String ga="rgb("+(255+-statevals[z])+",0,"+statevals[z]+")";
z++;
 String hi="rgb("+(255+-statevals[z])+",0,"+statevals[z]+")";
z++;
 String id="rgb("+(255+-statevals[z])+",0,"+statevals[z]+")";
z++;
 String il="rgb("+(255+-statevals[z])+",0,"+statevals[z]+")";
z++;
 String in="rgb("+(255+-statevals[z])+",0,"+statevals[z]+")";
z++;
 String ia="rgb("+(255+-statevals[z])+",0,"+statevals[z]+")";
z++;
 String ks="rgb("+(255+-statevals[z])+",0,"+statevals[z]+")";
z++;
 String ky="rgb("+(255+-statevals[z])+",0,"+statevals[z]+")";
z++;
 String la="rgb("+(255+-statevals[z])+",0,"+statevals[z]+")";
z++;
 String me="rgb("+(255+-statevals[z])+",0,"+statevals[z]+")";
z++;
 String md="rgb("+(255+-statevals[z])+",0,"+statevals[z]+")";
z++;
 String ma="rgb("+(255+-statevals[z])+",0,"+statevals[z]+")";
z++;
 String mi="rgb("+(255+-statevals[z])+",0,"+statevals[z]+")";
z++;
 String mn="rgb("+(255+-statevals[z])+",0,"+statevals[z]+")";
z++;
 String ms="rgb("+(255+-statevals[z])+",0,"+statevals[z]+")";
z++;
 String mo="rgb("+(255+-statevals[z])+",0,"+statevals[z]+")";
z++;
 String mt="rgb("+(255+-statevals[z])+",0,"+statevals[z]+")";
z++;
 String ne="rgb("+(255+-statevals[z])+",0,"+statevals[z]+")";
z++;
 String nv="rgb("+(255+-statevals[z])+",0,"+statevals[z]+")";
z++;
 String nh="rgb("+(255+-statevals[z])+",0,"+statevals[z]+")";
z++;
 String nj="rgb("+(255+-statevals[z])+",0,"+statevals[z]+")";
z++;
 String nm="rgb("+(255+-statevals[z])+",0,"+statevals[z]+")";
z++;
 String ny="rgb("+(255+-statevals[z])+",0,"+statevals[z]+")";
z++;
 String nc="rgb("+(255+-statevals[z])+",0,"+statevals[z]+")";
z++;
 String nd="rgb("+(255+-statevals[z])+",0,"+statevals[z]+")";
z++;
 String oh="rgb("+(255+-statevals[z])+",0,"+statevals[z]+")";
z++;
 String ok="rgb("+(255+-statevals[z])+",0,"+statevals[z]+")";
z++;
 String or="rgb("+(255+-statevals[z])+",0,"+statevals[z]+")";
z++;
 String pa="rgb("+(255+-statevals[z])+",0,"+statevals[z]+")";
z++;
 String ri="rgb("+(255+-statevals[z])+",0,"+statevals[z]+")";
z++;
 String sc="rgb("+(255+-statevals[z])+",0,"+statevals[z]+")";
z++;
 String sd="rgb("+(255+-statevals[z])+",0,"+statevals[z]+")";
z++;
 String tn="rgb("+(255+-statevals[z])+",0,"+statevals[z]+")";
z++;
 String tx="rgb("+(255+-statevals[z])+",0,"+statevals[z]+")";
z++;
 String ut="rgb("+(255+-statevals[z])+",0,"+statevals[z]+")";
z++;
 String vt="rgb("+(255+-statevals[z])+",0,"+statevals[z]+")";
z++;
 String va="rgb("+(255+-statevals[z])+",0,"+statevals[z]+")";
z++;
 String wa="rgb("+(255+-statevals[z])+",0,"+statevals[z]+")";
z++;
 String wv="rgb("+(255+-statevals[z])+",0,"+statevals[z]+")";
z++;
 String wi="rgb("+(255+-statevals[z])+",0,"+statevals[z]+")";
z++;
 String wy="rgb("+(255+-statevals[z])+",0,"+statevals[z]+")";

page.println("<div id=\"placement\">");
page.println("<?xml versi<a onmouseover=\"display(this)\" onmouseout=\"clearit(this)\" href=on=\"1.0\" encoding=\"utf-8\"?><!-- Generator: Adobe Illustrator 12.0.0, SVG Export Plug-In . SVG Version: 6.00 Build 51448)  --><!DOCTYPE svg PUBLIC \"-//W3C//DTD SVG 1.1//EN\" \"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd\" [  <!ENTITY ns_svg \"http://www.w3.org/2000/svg\">  <!ENTITY ns_xlink \"http://www.w3.org/1999/xlink\">]><svg  version=\"1.1\"   id=\"svg2\" xmlns:dc=\"http://purl.org/dc/elements/1.1/\" xmlns:cc=\"http://web.resource.org/cc/\" xmlns:inkscape=\"http://www.inkscape.org/namespaces/inkscape\" xmlns:sodipodi=\"http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd\" sodipodi:version=\"0.32\" xmlns:svg=\"http://www.w3.org/2000/svg\" xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\" sodipodi:docname=\"Blank US Map.svg\" inkscape:version=\"0.44\" sodipodi:docbase=\"/home/theshibboleth/Desktop/Wiki/election maps\"   xmlns=\"&ns_svg;\" xmlns:xlink=\"&ns_xlink;\" width=\"1368\" height=\"936\" viewBox=\"0 0 1368 936\"   overflow=\"visible\" enable-background=\"new 0 0 1368 936\" xml:space=\"preserve\"><sodipodi:namedview  fill=\""+mycolor+"\" inkscape:window-x=\"0\" inkscape:window-y=\"25\" showguides=\"true\" inkscape:current-layer=\"svg2\" inkscape:guide-bbox=\"true\" showgrid=\"false\" inkscape:window-height=\"796\" inkscape:window-width=\"1430\" inkscape:pageshadow=\"2\" inkscape:pageopacity=\"0.0\" id=\"base\" pagecolor=\"#ffffff\" borderopacity=\"1.0\" bordercolor=\"#666666\" inkscape:cx=\"374.60758\" inkscape:zoom=\"0.99999999\" inkscape:cy=\"340.17222\">  </sodipodi:namedview><a onmouseover=\"display(this)\" onmouseout=\"clearit(this)\" href=\"Hawaii.html\"><path id=\"HI\" fill=\""+hi+"\" d=\"M521.087,690.31l1.939-3.557l2.263-0.323l0.324,0.809l-2.102,3.071H521.087L521.087,690.31z   M531.271,686.591l6.143,2.587l2.103-0.323l1.617-3.88l-0.647-3.396l-4.203-0.484l-4.042,1.777L531.271,686.591z M561.987,696.613  l3.718,5.496l2.426-0.323l1.132-0.483l1.455,1.293l3.718-0.162l0.97-1.454l-2.91-1.778l-1.939-3.719l-2.103-3.558l-5.82,2.91  L561.987,696.613z M582.194,705.506l1.293-1.94l4.688,0.97l0.646-0.483l6.144,0.646l-0.323,1.293l-2.587,1.455l-4.365-0.323  L582.194,705.506z M587.529,710.679l1.94,3.88l3.071-1.132l0.323-1.616l-1.617-2.103l-3.718-0.322V710.679L587.529,710.679z   M594.48,709.547l2.264-2.909l4.688,2.425l4.365,1.131l4.364,2.749v1.939l-3.557,1.777l-4.85,0.97l-2.426-1.454L594.48,709.547z   M611.133,725.065l1.616-1.293l3.396,1.616l7.598,3.557l3.396,2.103l1.616,2.425l1.94,4.364l4.042,2.588l-0.323,1.293l-3.88,3.232  l-4.203,1.455l-1.455-0.646l-3.071,1.777l-2.425,3.233l-2.263,2.909l-1.778-0.162l-3.557-2.586l-0.323-4.525l0.646-2.426  l-1.615-5.657l-2.103-1.778l-0.162-2.587l2.265-0.97l2.102-3.072l0.485-0.971l-1.617-1.777L611.133,725.065z\"/></a><a onmouseover=\"display(this)\" onmouseout=\"clearit(this)\" href=\"Alaska.html\"><path id=\"AK\" fill=\""+ak+"\" d=\"M446.076,615.675l-0.322,85.356l1.616,0.971l3.071,0.161l1.455-1.132h2.586l0.162,2.91l6.952,6.789  l0.484,2.587l3.396-1.939l0.646-0.162l0.324-3.07l1.455-1.617l1.132-0.161l1.94-1.455l3.07,2.103l0.647,2.909l1.939,1.131  l1.132,2.427l3.88,1.776l3.395,5.982l2.748,3.88l2.263,2.748l1.455,3.718l5.012,1.778l5.174,2.102l0.97,4.365l0.484,3.071  l-0.97,3.395l-1.777,2.264l-1.617-0.809l-1.455-3.071l-2.748-1.455l-1.778-1.132l-0.809,0.809l1.455,2.748l0.161,3.72l-1.131,0.483  l-1.939-1.938l-2.103-1.294l0.485,1.616l1.293,1.778l-0.808,0.809c0,0-0.809-0.324-1.294-0.971  c-0.484-0.646-2.102-3.396-2.102-3.396l-0.97-2.264c0,0-0.323,1.294-0.971,0.971c-0.646-0.324-1.293-1.455-1.293-1.455l1.778-1.939  l-1.455-1.455v-5.011h-0.808l-0.81,3.395l-1.132,0.485l-0.97-3.72l-0.646-3.718l-0.809-0.485l0.323,5.658v1.132l-1.455-1.293  l-3.558-5.981l-2.102-0.484l-0.647-3.719l-1.616-2.909l-1.616-1.132v-2.265l2.102-1.293l-0.485-0.323l-2.587,0.646l-3.395-2.425  l-2.587-2.91l-4.851-2.586l-4.042-2.588l1.293-3.232v-1.616l-1.777,1.616l-2.91,1.132l-3.718-1.132l-5.658-2.426h-5.497  l-0.646,0.485l-6.466-3.88l-2.102-0.323l-2.749-5.82l-3.557,0.323l-3.557,1.455l0.484,4.526l1.133-2.91l0.97,0.322l-1.455,4.365  l3.232-2.748l0.646,1.616l-3.88,4.365l-1.293-0.323l-0.485-1.94l-1.293-0.808l-1.293,1.131l-2.748-1.778l-3.072,2.103l-1.777,2.103  l-3.396,2.103l-4.688-0.162l-0.485-2.103l3.718-0.646v-1.294l-2.263-0.646l0.97-2.425l2.263-3.88v-1.778l0.162-0.808l4.365-2.265  l0.97,1.293h2.749l-1.293-2.586l-3.718-0.323l-5.012,2.748l-2.426,3.396l-1.777,2.587l-1.131,2.263l-4.203,1.455l-3.072,2.587  l-0.323,1.616l2.263,0.971l0.809,2.102l-2.748,3.232l-6.466,4.203l-7.761,4.204l-2.102,1.131l-5.335,1.132l-5.335,2.264l1.777,1.293  l-1.455,1.455l-0.484,1.132l-2.748-0.971l-3.233,0.162l-0.808,2.264h-0.97l0.322-2.426l-3.556,1.294l-2.91,0.97l-3.395-1.293  l-2.91,1.938h-3.233l-2.102,1.293l-1.617,0.81l-2.103-0.323l-2.586-1.132l-2.263,0.646l-0.97,0.972l-1.616-1.133v-1.939l3.071-1.293  l6.305,0.646l4.365-1.616l2.102-2.102l2.91-0.646l1.778-0.809l2.748,0.162l1.616,1.293l0.971-0.323l2.263-2.748l3.071-0.971  l3.395-0.646l1.293-0.323l0.646,0.485h0.809l1.293-3.719l4.042-1.455l1.939-3.719l2.264-4.525l1.617-1.455l0.322-2.587l-1.616,1.294  l-3.395,0.646l-0.646-2.425l-1.293-0.323l-0.97,0.97l-0.162,2.91l-1.455-0.162l-1.455-5.818l-1.293,1.293l-1.131-0.485l-0.324-1.939  l-4.042,0.161l-2.102,1.132l-2.586-0.323l1.455-1.454l0.484-2.588l-0.646-1.938l1.455-0.97l1.293-0.162l-0.646-1.778V688.1  l-0.97-0.971l-0.809,1.454h-6.143l-1.455-1.293l-0.646-3.88l-2.103-3.557v-0.97l2.103-0.81l0.161-2.102l1.132-1.133l-0.809-0.483  l-1.293,0.483l-1.131-2.748l0.97-5.012l4.526-3.233l2.587-1.615l1.939-3.719l2.748-1.294l2.586,1.132l0.324,2.426l2.425-0.323  l3.233-2.425l1.617,0.646l0.97,0.646h1.617l2.263-1.293l0.808-4.365c0,0,0.323-2.909,0.971-3.396c0.646-0.484,0.97-0.97,0.97-0.97  l-1.131-1.94l-2.587,0.81l-3.233,0.809l-1.94-0.485L357,646.712l-5.012-0.161l-3.557-3.719l0.485-3.881l0.646-2.425l-2.102-1.778  l-1.94-3.718l0.485-0.809l6.79-0.485h2.102l0.971,0.971h0.646l-0.162-1.616l3.88-0.646l2.587,0.323l1.455,1.132l-1.455,2.102  l-0.484,1.455l2.749,1.616l5.011,1.778l1.778-0.971l-2.264-4.365l-0.97-3.232l0.97-0.809l-3.395-1.939l-0.485-1.132l0.485-1.616  l-0.809-3.88l-2.91-4.688l-2.425-4.203l2.91-1.938h3.233l1.777,0.646l4.204-0.162l3.718-3.556l1.133-3.072l3.718-2.425l1.617,0.97  l2.747-0.646l3.719-2.103l1.132-0.161l0.97,0.809l4.526-0.161l2.749-3.071h1.131l3.557,2.425l1.94,2.103l-0.485,1.131l0.646,1.132  l1.616-1.616l3.88,0.323l0.323,3.718l1.94,1.455l7.112,0.646l6.306,4.204l1.455-0.971l5.173,2.587l2.102-0.646l1.94-0.809  l4.85,1.939L446.076,615.675z M330.974,644.611l2.102,5.335l-0.162,0.97l-2.909-0.322l-1.778-4.041l-1.778-1.455h-2.425  l-0.162-2.587l1.778-2.426l1.131,2.426l1.455,1.454L330.974,644.611z M328.387,678.075l3.718,0.81l3.718,0.97l0.809,0.97  l-1.616,3.719l-3.072-0.161l-3.395-3.558L328.387,678.075z M307.694,664.012l1.131,2.587l1.132,1.616l-1.132,0.809l-2.102-3.072  v-1.938L307.694,664.012L307.694,664.012z M293.954,737.082l3.395-2.264l3.395-0.97l2.587,0.323l0.485,1.615l1.94,0.485l1.939-1.94  l-0.323-1.615l2.748-0.646l2.91,2.587l-1.131,1.777l-4.365,1.132l-2.749-0.484l-3.718-1.132l-4.365,1.455l-1.617,0.323  L293.954,737.082z M342.937,732.556l1.617,1.939l2.102-1.616l-1.455-1.294L342.937,732.556z M345.847,735.628l1.132-2.265  l2.102,0.323l-0.809,1.939h-2.425V735.628z M369.448,733.688l1.455,1.778l0.97-1.133l-0.808-1.938L369.448,733.688z   M378.179,721.239l1.131,5.819l2.91,0.809l5.011-2.91l4.365-2.587l-1.616-2.425l0.485-2.425l-2.103,1.293l-2.91-0.809l1.617-1.132  l1.94,0.81l3.88-1.778l0.484-1.455l-2.425-0.81l0.809-1.938l-2.749,1.938l-4.688,3.558l-4.85,2.91L378.179,721.239z   M420.533,701.354l2.426-1.455l-0.971-1.778l-1.777,0.971L420.533,701.354z\"/></a><a onmouseover=\"display(this)\" onmouseout=\"clearit(this)\" href=\"Florida.html\"><path id=\"FL\" sodipodi:nodetypes=\"cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc\" fill=\""+fl+"\" d=\"  M1043.396,607.507l2.266,7.317l3.729,9.742l5.335,9.377l3.718,6.305l4.85,5.496l4.042,3.718l1.616,2.91l-1.131,1.293l-0.81,1.294  l2.91,7.438l2.909,2.908l2.587,5.335l3.557,5.82l4.526,8.244l1.293,7.599l0.484,11.963l0.646,1.778l-0.323,3.395l-2.425,1.293  l0.322,1.94l-0.646,1.938l0.322,2.426l0.485,1.939l-2.749,3.233l-3.071,1.454l-3.88,0.161l-1.455,1.616l-2.425,0.971l-1.293-0.484  l-1.132-0.971l-0.323-2.909l-0.81-3.396l-3.395-5.174l-3.558-2.263l-3.88-0.323l-0.809,1.293l-3.071-4.365l-0.646-3.556  l-2.587-4.043l-1.778-1.132l-1.615,2.103l-1.778-0.323l-2.103-5.012l-2.91-3.88l-2.908-5.335l-2.588-3.071l-3.557-3.719l2.102-2.425  l3.233-5.496l-0.162-1.617l-4.526-0.97l-1.616,0.646l0.323,0.646l2.587,0.97l-1.455,4.527l-0.809,0.484l-1.778-4.041l-1.293-4.852  l-0.323-2.748l1.455-4.688v-9.538l-3.072-3.72l-1.293-3.07l-5.173-1.294l-1.94-0.646l-1.616-2.587l-3.396-1.616l-1.131-3.396  l-2.749-0.97l-2.426-3.719l-4.202-1.454l-2.91-1.455h-2.586l-4.043,0.808l-0.16,1.94l0.809,0.97l-0.485,1.132l-3.07-0.162  l-3.72,3.558l-3.557,1.939h-3.88l-3.233,1.293l-0.322-2.748l-1.616-1.939l-2.91-1.132l-1.616-1.455l-8.083-3.88l-7.599-1.777  l-4.364,0.646l-5.981,0.485l-5.98,2.102l-3.479,0.612l-0.237-8.05l-2.587-1.939l-1.778-1.778l0.323-3.07l10.186-1.295l25.543-2.908  l6.789-0.646l5.437,0.28l2.586,3.88l1.455,1.454l8.099,0.516l10.819-0.646l21.513-1.294l5.445-0.674l4.577,0.027l0.161,2.91  l3.824,0.809l0.323-4.807l-1.617-4.527l0.955-0.732l5.113,0.455L1043.396,607.507z M1055.941,739.911l2.425-0.646l1.294-0.243  l1.455-2.344l2.344-1.616l1.293,0.483l1.698,0.323l0.403,1.051l-3.477,1.213l-4.203,1.455l-2.344,1.212L1055.941,739.911z   M1069.44,734.899l1.213,1.051l2.748-2.102l5.335-4.203l3.718-3.88l2.506-6.628l0.97-1.697l0.162-3.396l-0.728,0.485l-0.972,2.829  l-1.454,4.606l-3.232,5.254l-4.365,4.203l-3.396,1.939L1069.44,734.899z\"/></a><a onmouseover=\"display(this)\" onmouseout=\"clearit(this)\" href=\"South%20Carolina.html\"><path id=\"SC\" fill=\""+sc+"\" d=\"M1049.229,574.938l-1.776,0.97l-2.587-1.293l-0.646-2.102l-1.293-3.558l-2.265-2.102l-2.586-0.646  l-1.617-4.851l-2.748-5.981l-4.203-1.938l-2.102-1.94l-1.293-2.586l-2.104-1.94l-2.263-1.293l-2.265-2.909l-3.07-2.264l-4.526-1.777  l-0.485-1.455l-2.425-2.91l-0.483-1.455l-3.396-5.173l-3.396,0.161l-4.042-2.426l-1.293-1.293l-0.322-1.778l0.809-1.938l2.263-0.971  l-0.323-2.103l6.145-2.586l9.053-4.526l7.274-0.809l16.488-0.485l2.265,1.94l1.615,3.232l4.365-0.484l12.609-1.455l2.909,0.809  l12.609,7.598l10.107,8.122l-5.422,5.458l-2.586,6.145l-0.485,6.305l-1.616,0.808l-1.132,2.749l-2.425,0.646l-2.103,3.557  l-2.748,2.748l-2.264,3.395l-1.616,0.81l-3.557,3.395l-2.91,0.162l0.97,3.233l-5.012,5.496L1049.229,574.938z\"/></a><a onmouseover=\"display(this)\" onmouseout=\"clearit(this)\" href=\"Georgia.html\"><path id=\"GA\" sodipodi:nodetypes=\"ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc\" fill=\""+ga+"\" d=\"  M977.615,519.973l-4.85,0.809l-8.406,1.132l-8.568,0.89v2.183l0.162,2.102l0.646,3.396l3.395,7.922l2.425,9.861l1.455,6.143  l1.617,4.85l1.455,6.952l2.102,6.306l2.586,3.395l0.485,3.396l1.939,0.809l0.161,2.102l-1.777,4.851l-0.485,3.232l-0.161,1.94  l1.616,4.363l0.323,5.335l-0.809,2.426l0.646,0.809l1.455,0.809l0.646,3.396l2.586,3.88l1.455,1.455l7.922,0.161l10.819-0.646  l21.513-1.293l5.445-0.675l4.576,0.027l0.162,2.909l2.587,0.809l0.323-4.363l-1.617-4.527l1.132-1.616l5.819,0.81l4.978,0.316  l-0.774-6.299l2.264-10.022l1.455-4.202l-0.485-2.588l3.335-6.243l-0.511-1.353l-1.913,0.704l-2.587-1.293l-0.646-2.103  l-1.293-3.557l-2.265-2.103l-2.587-0.646l-1.616-4.851l-2.925-6.335l-4.203-1.939l-2.102-1.939l-1.294-2.587l-2.103-1.939  l-2.263-1.293l-2.265-2.91l-3.07-2.264l-4.526-1.777l-0.485-1.455l-2.425-2.91l-0.485-1.455l-3.395-4.907l-3.396,0.161l-4.13-3.044  l-1.294-1.293l-0.323-1.778l0.81-1.938l2.352-1.235L997.1,518l0.078-0.291l-5.82,0.971l-6.951,0.808L977.615,519.973z\"/></a><a onmouseover=\"display(this)\" onmouseout=\"clearit(this)\" href=\"Alabama.html\"><path id=\"AL\" sodipodi:nodetypes=\"cccccccccccccccccccccccccccccccccccccccccccccccccc\" fill=\""+al+"\" d=\"M913.598,628.771  l-1.615-15.196l-2.748-18.753l0.161-14.063l0.809-31.038l-0.162-16.651l0.165-6.419l7.757-0.371l27.807-2.586l8.922-0.663  l-0.147,2.183l0.162,2.103l0.646,3.396l3.395,7.921l2.425,9.861l1.455,6.144l1.617,4.851l1.454,6.951l2.103,6.305l2.586,3.396  l0.485,3.396l1.938,0.809l0.162,2.103l-1.777,4.85l-0.485,3.233l-0.161,1.938l1.616,4.365l0.322,5.335l-0.809,2.425l0.647,0.808  l1.453,0.81l1.035,2.535h-6.305l-6.789,0.646l-25.543,2.91l-10.411,1.407l-0.097,3.752l1.777,1.777l2.587,1.939l0.581,7.936  l-5.542,2.573l-2.749-0.323l2.749-1.939v-0.971l-3.072-5.98l-2.263-0.646l-1.455,4.365l-1.294,2.748l-0.646-0.162h-2.746V628.771z\"  /></a><a onmouseover=\"display(this)\" onmouseout=\"clearit(this)\" href=\"North%20Carolina.html\"><path id=\"NC\" sodipodi:nodetypes=\"ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccscccccccccccccccccccccccccccccccc\" fill=\""+nc+"\" d=\"  M1120.105,460.472l1.71,4.699l3.557,6.466l2.425,2.425l0.646,2.264l-2.425,0.161l0.809,0.646l-0.323,4.202l-2.587,1.294  l-0.646,2.103l-1.293,2.91l-3.719,1.615l-2.425-0.322l-1.455-0.162l-1.616-1.293l0.323,1.293v0.971h1.938l0.809,1.293l-1.938,6.305  h4.203l0.646,1.616l2.263-2.263l1.294-0.485l-1.939,3.558l-3.071,4.85h-1.293l-1.132-0.484l-2.748,0.646l-5.175,2.425l-6.466,5.335  l-3.396,4.688l-1.938,6.467l-0.485,2.425l-4.688,0.485l-5.452,1.337l-9.946-8.203l-12.61-7.599l-2.909-0.809l-12.608,1.455  l-4.277,0.75l-1.616-3.233l-2.971-2.116l-16.489,0.484l-7.274,0.809l-9.053,4.526l-6.145,2.587L997,516.915l-5.82,0.97l-6.951,0.809  l-6.79,0.485l0.5-4.055l1.778-1.455l2.749-0.646l0.646-3.719l4.203-2.748l3.88-1.455l4.203-3.557l4.363-2.103l0.646-3.071  l3.881-3.88l0.646-0.161c0,0,0,1.132,0.808,1.132c0.809,0,1.939,0.322,1.939,0.322l2.264-3.556l2.102-0.647l2.264,0.324l1.616-3.557  l2.91-2.587l0.485-2.103v-3.961l4.525,0.729l7.136-1.294l15.82-1.939l17.136-2.586l19.922-4.001l19.733-4.165l11.364-2.796  L1120.105,460.472z M1124.002,493.46l2.587-2.507l3.151-2.587l1.535-0.646l0.162-2.021l-0.646-6.144l-1.455-2.345l-0.646-1.858  l0.728-0.242l2.748,5.496l0.403,4.446l-0.162,3.395l-3.395,1.536l-2.829,2.425l-1.132,1.212L1124.002,493.46z\"/></a><a onmouseover=\"display(this)\" onmouseout=\"clearit(this)\" href=\"Tennessee.html\"><path id=\"TN\" sodipodi:nodetypes=\"ccccccccccccccccccccccccccccccccccccccsccccccccccccc\" fill=\""+tn+"\" d=\"M985.053,482.629  l-51.894,5.012l-15.76,1.778l-4.621,0.513l-3.869-0.027v3.879l-8.405,0.485l-6.951,0.646l-11.097,0.054l-0.265,5.836l-2.139,6.274  l-0.995,3.018l-1.35,4.381l-0.323,2.586l-4.041,2.264l1.455,3.558l-0.971,4.363l-0.968,0.79l7.256-0.194l24.087-1.938l5.335-0.162  l8.083-0.485l27.806-2.586l10.171-0.809l8.42-0.971l8.406-1.132l4.851-0.809l-0.131-4.509l1.778-1.455l2.748-0.646l0.646-3.719  l4.203-2.748l3.88-1.455l4.203-3.558l4.365-2.102l0.874-3.525l4.333-3.88l0.646-0.161c0,0,0,1.131,0.809,1.131  c0.81,0,1.94,0.324,1.94,0.324l2.263-3.557l2.103-0.647l2.264,0.324l1.616-3.557l2.114-2.246l0.6-0.967l0.177-3.934l-1.483-0.288  l-2.425,1.939l-7.922,0.162l-11.995,1.899L985.053,482.629z\"/></a><a onmouseover=\"display(this)\" onmouseout=\"clearit(this)\" href=\"Rhode%20Island.html\"><path id=\"RI\" fill=\""+ri+"\" d=\"M1162.069,341.823l-0.482-4.204l-0.809-4.365l-1.698-5.9l5.739-1.536l1.616,1.131l3.396,4.365  l2.908,4.446l-2.91,1.536l-1.294-0.162l-1.132,1.778l-2.426,1.94L1162.069,341.823z\"/></a><a onmouseover=\"display(this)\" onmouseout=\"clearit(this)\" href=\"Connecticut.html\"><path id=\"CT\" sodipodi:nodetypes=\"cccccccccccccccccc\" fill=\""+ct+"\" d=\"M1161.192,342.05l-0.628-4.205l-0.808-4.365l-1.617-5.981  l-4.151,0.904l-21.824,4.769l0.646,3.314l1.455,7.275v8.083l-1.133,2.263l1.832,2.109l4.956-3.401l3.556-3.233l1.94-2.102  l0.809,0.646l2.748-1.455l5.173-1.132L1161.192,342.05z\"/></a><a onmouseover=\"display(this)\" onmouseout=\"clearit(this)\" href=\"Massachusetts.html\"><path id=\"MA\" sodipodi:nodetypes=\"ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc\" fill=\""+ma+"\" d=\"  M1187.977,335.851l2.172-0.686l0.458-1.714l1.028,0.114l1.028,2.286l-1.258,0.458l-3.887,0.114L1187.977,335.851z M1178.604,336.651  l2.286-2.629h1.601l1.829,1.486l-2.401,1.029l-2.172,1.029L1178.604,336.651z M1143.805,314.663l17.459-4.203l2.264-0.646  l2.102-3.233l3.736-1.663l2.89,4.413l-2.425,5.173l-0.324,1.455l1.94,2.586l1.132-0.808h1.777l2.264,2.586l3.88,5.981l3.557,0.485  l2.264-0.97l1.778-1.778l-0.81-2.749l-2.102-1.617l-1.455,0.809l-0.971-1.293l0.484-0.485l2.103-0.162l1.777,0.808l1.939,2.425  l0.971,2.91l0.322,2.425l-4.202,1.455l-3.881,1.94l-3.88,4.526l-1.938,1.455v-0.97l2.425-1.455l0.483-1.778l-0.808-3.072  l-2.91,1.455l-0.81,1.455l0.485,2.263l-2.066,1l-2.747-4.527l-3.395-4.365l-2.071-1.812l-6.533,1.876l-5.092,1.051l-21.824,4.769  l-0.402-4.944l0.646-10.589l5.173-0.889L1143.805,314.663\"/></a><a onmouseover=\"display(this)\" onmouseout=\"clearit(this)\" href=\"Maine.html\"><path id=\"ME\" sodipodi:nodetypes=\"ccccccccsccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccsccccc\" fill=\""+me+"\" d=\"  M1211.215,239.331l1.938,2.102l2.264,3.718v1.94l-2.102,4.688l-1.94,0.647l-3.395,3.071l-4.851,5.497c0,0-0.646,0-1.294,0  c-0.646,0-0.97-2.102-0.97-2.102l-1.778,0.162l-0.97,1.455l-2.426,1.455l-0.97,1.455l1.616,1.455l-0.484,0.646l-0.485,2.749  l-1.939-0.162v-1.617l-0.323-1.293l-1.454,0.323l-1.778-3.233l-2.103,1.293l1.294,1.455l0.322,1.132l-0.809,1.293l0.323,3.072  l0.162,1.617l-1.616,2.586l-2.91,0.485l-0.323,2.91l-5.335,3.071l-1.293,0.485l-1.617-1.455l-3.071,3.556l0.97,3.233l-1.455,1.293  l-0.161,4.365l-1.124,6.259l-2.462-1.156l-0.484-3.072l-3.88-1.131l-0.323-2.749l-7.274-23.441l-4.198-13.64l1.42-0.118l1.514,0.41  v-2.587l0.81-5.496l2.587-4.688l1.455-4.042l-1.94-2.425v-5.981l0.809-0.97l0.81-2.749l-0.162-1.455l-0.162-4.85l1.778-4.85  l2.909-8.892l2.102-4.203h1.294l1.293,0.162v1.132l1.293,2.263l2.748,0.646l0.81-0.808v-0.97l4.042-2.91l1.777-1.778l1.454,0.162  l5.981,2.425l1.939,0.97l9.053,29.907h5.981l0.809,1.94l0.161,4.85l2.91,2.263h0.809l0.161-0.485l-0.484-1.132L1211.215,239.331z   M1190.282,269.479l1.535-1.536l1.375,1.051l0.565,2.425l-1.697,0.889L1190.282,269.479z M1196.991,263.578l1.778,1.859  c0,0,1.293,0.081,1.293-0.242c0-0.323,0.242-2.021,0.242-2.021l0.89-0.808l-0.81-1.778l-2.021,0.728L1196.991,263.578z\"/></a><a onmouseover=\"display(this)\" onmouseout=\"clearit(this)\" href=\"New%20Hampshire.html\"><path id=\"NH\" sodipodi:nodetypes=\"ccccccccccccccccccccccccccccccccc\" fill=\""+nh+"\" d=\"M1168.799,304.425l0.868-1.077l1.091-3.291  l-2.544-0.914l-0.483-3.071l-3.88-1.132l-0.323-2.748l-7.275-23.441l-4.602-14.543l-0.896-0.005l-0.646,1.617l-0.646-0.485  l-0.972-0.97l-1.455,1.94l-0.048,5.032l0.312,5.667l1.938,2.748v4.042l-3.718,5.063l-2.587,1.131v1.132l1.132,1.778v8.568  l-0.81,9.215l-0.161,4.85l0.971,1.293l-0.161,4.526l-0.485,1.778l1.455,0.886l16.39-4.69l2.264-0.646l1.534-2.552L1168.799,304.425z  \"/></a><a onmouseover=\"display(this)\" onmouseout=\"clearit(this)\" href=\"Vermont.html\"><path id=\"VT\" sodipodi:nodetypes=\"ccccccccccccccccccccccccccccc\" fill=\""+vt+"\" d=\"M1132.344,315.727l-0.81-5.658l-2.391-9.972  l-0.646-0.323l-2.91-1.293l0.81-2.91l-0.81-2.102l-2.7-4.64l0.971-3.88l-0.809-5.173l-2.425-6.466l-0.807-4.922l26.247-6.748  l0.324,5.819l1.94,2.749v4.042l-3.72,4.042l-2.586,1.131v1.132l1.132,1.778v8.568l-0.809,9.215l-0.162,4.85l0.971,1.293  l-0.162,4.526l-0.485,1.778l0.661,1.567l-6.951,1.374L1132.344,315.727z\"/></a><a onmouseover=\"display(this)\" onmouseout=\"clearit(this)\" href=\"New%20York.html\"><path id=\"NY\" sodipodi:nodetypes=\"cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc\" fill=\""+ny+"\" d=\"  M1116.613,351.422l-1.132-0.97l-2.586-0.161l-2.265-1.94l-1.631-6.129l-3.458,0.091l-2.444-2.708l-19.385,4.382l-43.002,8.73  l-7.529,1.228l-0.737-6.468l1.428-1.125l1.293-1.132l0.971-1.617l1.778-1.131l1.938-1.778l0.485-1.617l2.102-2.748l1.132-0.97  l-0.162-0.97l-1.293-3.072l-1.778-0.162l-1.939-6.143l2.91-1.778l4.364-1.455l4.041-1.293l3.233-0.485l6.305-0.161l1.938,1.293  l1.617,0.162l2.103-1.293l2.586-1.131l5.174-0.485l2.102-1.778l1.778-3.233l1.615-1.94h2.103l1.939-1.131l0.161-2.263l-1.455-2.102  l-0.323-1.455l1.132-2.102v-1.455h-1.777l-1.778-0.808l-0.81-1.132l-0.161-2.586l5.819-5.497l0.647-0.808l1.453-2.91l2.91-4.526  l2.748-3.718l2.102-2.425l2.416-1.826l3.081-1.246l5.496-1.293l3.233,0.162l4.525-1.455l7.565-2.071l0.52,4.98l2.425,6.466  l0.809,5.173l-0.97,3.88l2.586,4.527l0.809,2.102l-0.809,2.91l2.91,1.293l0.646,0.323l3.072,10.993l-0.537,5.06l-0.484,10.831  l0.809,5.497l0.809,3.557l1.455,7.274v8.083l-1.132,2.264l1.84,1.993l0.796,1.678l-1.939,1.778l0.323,1.293l1.293-0.323l1.455-1.293  l2.264-2.586l1.131-0.647l1.617,0.647l2.263,0.162l7.922-3.88l2.91-2.748l1.293-1.455l4.203,1.617l-3.396,3.556l-3.88,2.91  l-7.113,5.335l-2.587,0.97l-5.819,1.94l-4.042,1.131l-1.175-0.533l-0.244-3.688l0.485-2.748l-0.161-2.102l-2.814-1.699l-4.525-0.97  l-3.88-1.131L1116.613,351.422z\"/></a><a onmouseover=\"display(this)\" onmouseout=\"clearit(this)\" href=\"New%20Jersey.html\"><path id=\"NJ\" fill=\""+nj+"\" d=\"M1116.159,352.33l-2.102,2.425v3.072l-1.939,3.072l-0.162,1.616l1.293,1.293l-0.161,2.425  l-2.264,1.132l0.809,2.748l0.162,1.132l2.748,0.323l0.97,2.586l3.558,2.425l2.425,1.617v0.809l-3.233,3.071l-1.616,2.263  l-1.455,2.749l-2.264,1.293l-1.212,0.728l-0.242,1.212l-0.609,2.607l1.092,2.244l3.233,2.91l4.85,2.265l4.042,0.646l0.161,1.455  l-0.809,0.97l0.323,2.748h0.809l2.102-2.425l0.809-4.851l2.748-4.042l3.072-6.466l1.131-5.497l-0.646-1.132l-0.162-9.376  l-1.616-3.395l-1.132,0.808l-2.748,0.324l-0.483-0.485l1.131-0.97l2.102-1.94l0.063-1.094l-0.386-3.434l0.485-2.748l-0.162-2.102  l-2.586-1.132l-4.526-0.97l-3.88-1.132L1116.159,352.33z\"/></a><a onmouseover=\"display(this)\" onmouseout=\"clearit(this)\" href=\"Pennsylvania.html\"><path id=\"PA\" sodipodi:nodetypes=\"cccccccccccccccccccccccccccccccccccccccccccc\" fill=\""+pa+"\" d=\"M1110.206,388.46l1.133-0.647  l2.263-0.612l1.455-2.748l1.616-2.263l3.232-3.072v-0.808l-2.425-1.617l-3.558-2.425l-0.97-2.586l-2.748-0.323l-0.162-1.131  l-0.809-2.749l2.264-1.131l0.162-2.425l-1.295-1.293l0.162-1.617l1.939-3.072v-3.071l2.345-2.425l0.214-1.083l-2.586-0.162  l-2.264-1.94l-2.426-5.335l-3.005-0.931l-2.33-2.141l-18.591,4.041l-43.002,8.73l-8.892,1.455l-0.496-7.084l-5.486,5.63  l-1.294,0.485l-4.202,3.009l2.91,19.137l2.481,9.729l3.572,19.262l3.269-0.638l11.943-1.504l37.928-7.665l14.876-2.823l8.3-1.622  l0.268-0.239l2.103-1.617L1110.206,388.46z\"/></a><a onmouseover=\"display(this)\" onmouseout=\"clearit(this)\" href=\"Delaware.html\"><path id=\"DE\" sodipodi:nodetypes=\"cccccccccccccccccccc\" fill=\""+de+"\" d=\"M1110.353,392.423l0.589-2.103l0.021-1.205l-1.27-0.088  l-2.103,1.616l-1.454,1.455l1.453,4.203l2.265,5.657l2.102,9.7l1.617,6.305l5.011-0.161l6.143-1.213l-2.265-7.354l-0.97,0.485  l-3.558-2.426l-1.777-4.688l-1.939-3.558l-2.264-0.97l-2.103-3.556L1110.353,392.423z\"/></a><a onmouseover=\"display(this)\" onmouseout=\"clearit(this)\" href=\"Maryland.html\"><path id=\"MD\" sodipodi:nodetypes=\"ccccccccccccccccccccccccccccccccccccccccccccccccccsccccccccccccccccccccccccccccsccc\" fill=\""+md+"\" d=\"  M1124.952,417.305l-6.141,1.292l-5.808,0.162l-1.843-7.1l-2.102-9.7l-2.265-5.657l-1.288-4.398l-7.506,1.623l-14.877,2.823  l-37.451,7.551l1.132,5.012l0.97,5.658l0.323-0.323l2.103-2.425l2.263-2.618l2.426-0.616l1.455-1.455l1.776-2.587l1.294,0.646  l2.909-0.323l2.587-2.102l2.007-1.453l1.847-0.485l1.645,1.13l2.909,1.455l1.939,1.778l1.212,1.536l4.123,1.696v2.91l5.496,1.293  l1.145,0.542l1.412-2.028l2.882,1.971l-1.277,2.481l-0.767,3.986l-1.778,2.586v2.102l0.646,1.778l5.063,1.355l4.312-0.062l3.07,0.97  l2.103,0.323l0.97-2.102l-1.455-2.103v-1.778l-2.425-2.102l-2.103-5.497l1.293-5.335l-0.161-2.102l-1.293-1.294  c0,0,1.454-1.616,1.454-2.264c0-0.646,0.485-2.102,0.485-2.102l1.939-1.293l1.939-1.617l0.484,0.97l-1.455,1.616l-1.294,3.718  l0.324,1.132l1.777,0.323l0.484,5.497l-2.102,0.97l0.322,3.557l0.485-0.161l1.132-1.94l1.616,1.778l-1.616,1.293l-0.324,3.395  l2.587,3.396l3.88,0.484l1.617-0.808l3.236,4.183l1.357,0.537l6.653-2.797l2.008-4.023L1124.952,417.305z M1108.32,426.289  l1.131,2.507l0.162,1.777l1.132,1.859c0,0,0.89-0.89,0.89-1.212c0-0.323-0.729-3.072-0.729-3.072l-0.728-2.344L1108.32,426.289z\"/></a><a onmouseover=\"display(this)\" onmouseout=\"clearit(this)\" href=\"West%20Virginia.html\"><path id=\"WV\" sodipodi:nodetypes=\"cccccccccccccccccccccccccccccccccccccccccccscccccccccccccccccccccccccccccccccccccccccc\" fill=\""+wv+"\" d=\"  M1044.561,403.967l1.112,4.944l1.082,6.906l3.561-2.749l2.264-3.071l2.538-0.615l1.455-1.455l1.777-2.586l1.181,0.646l2.909-0.323  l2.586-2.102l2.008-1.453l1.846-0.485l1.304,1.017l2.229,1.114l1.939,1.778l1.374,1.293l-0.144,4.671l-5.658-3.072l-4.525-1.777  l-0.162,5.335l-0.484,2.102l-1.617,2.748l-0.646,1.617l-3.071,2.425l-0.485,2.263l-3.395,0.324l-0.323,3.071l-1.132,5.497h-2.588  l-1.293-0.809l-1.616-2.749l-1.777,0.162l-0.323,4.365l-2.103,6.628l-5.012,10.831l0.809,1.293l-0.162,2.748l-2.102,1.939  l-1.455-0.322l-3.233,2.425l-2.586-0.97l-1.778,4.688c0,0-3.719,0.809-4.365,0.97c-0.646,0.161-2.425-1.293-2.425-1.293  l-2.425,2.264l-2.587,0.646l-2.91-0.809l-1.293-1.293l-2.192-3.023l-3.143-1.988l-2.586-2.748l-2.91-3.718l-0.646-2.263  l-2.587-1.455l-0.809-1.617l-0.242-5.254l2.183-0.081l1.939-0.809l0.162-2.748l1.615-1.454l0.162-5.013l0.97-3.88l1.293-0.646  l1.294,1.132l0.484,1.777l1.778-0.97l0.484-1.617l-1.132-1.777v-2.426l0.97-1.293l2.265-3.395l1.293-1.455l2.102,0.485l2.264-1.617  l3.071-3.396l2.264-3.88l0.323-5.658l0.484-5.011v-4.688l-1.132-3.071l0.971-1.455l1.282-1.293l3.491,19.827l4.631-0.751  L1044.561,403.967z\"/></a><a onmouseover=\"display(this)\" onmouseout=\"clearit(this)\" href=\"Kentucky.html\"><path id=\"KY\" sodipodi:nodetypes=\"cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc\" fill=\""+ky+"\" d=\"  M1009.782,459.817l-2.325,2.684l-4.202,3.556l-4.3,5.903l-1.777,1.776v2.104l-3.88,2.102l-5.658,3.396l-3.521,0.385l-51.868,4.897  l-15.76,1.778l-4.621,0.513l-3.868-0.026l-0.228,4.22l-8.179,0.145l-6.951,0.647l-10.432,0.205l1.912-0.223l2.181-1.762l2.059-1.144  l0.229-3.2l0.914-1.829l-1.605-2.539l0.802-1.907l2.264-1.778l2.103-0.646l2.747,1.294l3.558,1.293l1.131-0.323l0.162-2.264  l-1.293-2.425l0.322-2.264l1.939-1.455l2.587-0.646l1.616-0.647l-0.809-1.777l-0.646-1.939l1.132-0.808l1.051-3.314l2.991-1.698  l5.818-0.97l3.558-0.485l1.455,1.94l1.777,0.809l1.778-3.232l2.91-1.455l1.938,1.617l0.81,1.132l2.102-0.485l-0.162-3.395  l2.91-1.617l1.132-0.809l1.132,1.616h4.688l0.809-2.102l-0.323-2.264l2.909-3.557l4.688-3.88l0.484-4.526l2.748-0.323l3.88-1.777  l2.748-1.94l-0.323-1.939l-1.455-1.455l0.566-2.183l4.122-0.243l2.425-0.808l2.91,1.617l1.616,4.365l5.819,0.322l1.778,1.778  l2.102,0.162l2.425-1.455l3.071,0.485l1.293,1.454l2.748-2.586l1.779-1.293h1.615l0.646,2.749l1.778,0.971l2.422,2.215l0.161,5.496  l0.809,1.616l2.587,1.455l0.646,2.264l2.91,3.718l2.586,2.748L1009.782,459.817z\"/></a><a onmouseover=\"display(this)\" onmouseout=\"clearit(this)\" href=\"Ohio.html\"><path id=\"OH\" sodipodi:nodetypes=\"cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc\" fill=\""+oh+"\" d=\"  M1019.436,357.008l-6.094,4.053l-3.879,2.263l-3.396,3.718l-4.041,3.88l-3.233,0.808l-2.91,0.485l-5.495,2.586l-2.103,0.162  l-3.395-3.071l-5.175,0.646l-2.586-1.455l-2.382-1.351l-4.893,0.703l-10.186,1.617l-7.76,1.212l1.294,14.63l1.777,13.74  l2.587,23.441l0.565,4.831l4.122-0.129l2.425-0.81l3.363,1.503l2.071,4.365l5.139-0.017l1.892,2.119l1.762-0.065l2.538-1.341  l2.504,0.372l1.976,1.455l1.727-2.133l2.346-1.293l2.07-0.681l0.646,2.748l1.777,0.97l3.478,2.344l2.182-0.08l1.146-1.149  l-0.064-1.387l1.617-1.455l0.16-5.013l0.972-3.88l1.52-1.44l1.521,0.904l0.824,1.211l1.211-0.176l-0.423-2.411l-0.562-0.644v-2.425  l0.97-1.293l2.263-3.396l1.294-1.455l2.103,0.485l2.263-1.617l3.071-3.396l2.264-3.88l0.21-5.431l0.485-5.011v-4.688l-1.133-3.071  l0.971-1.455l0.921-0.955l-1.405-9.843L1019.436,357.008z\"/></a><a onmouseover=\"display(this)\" onmouseout=\"clearit(this)\" href=\"Michigan.html\"><path id=\"MI\" sodipodi:nodetypes=\"ccccccccccccccsccccccccccccccccsccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc\" fill=\""+mi+"\" d=\"  M869.618,244.059l1.829-2.058l2.172-0.8l5.373-3.887l2.286-0.571l0.457,0.457l-5.145,5.144l-3.314,1.943l-2.058,0.915  L869.618,244.059z M955.794,276.187l0.646,2.506l3.233,0.162l1.293-1.212c0,0-0.081-1.455-0.404-1.617  c-0.323-0.162-1.616-1.859-1.616-1.859l-2.183,0.243l-1.617,0.161l-0.322,1.132L955.794,276.187z M985.859,339.237l-3.232-8.245  l-2.265-9.053l-2.425-3.233l-2.586-1.778l-1.617,1.132l-3.88,1.778l-1.939,5.011l-2.748,3.718l-1.132,0.646l-1.455-0.646  c0,0-2.587-1.455-2.425-2.102c0.161-0.646,0.483-5.012,0.483-5.012l3.396-1.293l0.808-3.395l0.647-2.586l2.425-1.617l-0.323-10.023  l-1.617-2.263l-1.293-0.809l-0.809-2.102l0.809-0.808l1.616,0.323l0.162-1.617L964.035,293l-1.294-2.586h-2.587l-4.525-1.455  l-5.497-3.395h-2.748l-0.646,0.647l-0.97-0.485l-3.072-2.264l-2.909,1.778l-2.909,2.263l0.322,3.557l0.971,0.323l2.102,0.485  l0.485,0.809l-2.588,0.808l-2.586,0.324l-1.455,1.778l-0.322,2.102l0.322,1.616l0.323,5.497l-3.557,2.102l-0.646-0.162v-4.203  l1.293-2.425l0.646-2.425l-0.809-0.809l-1.939,0.809l-0.971,4.203l-2.748,1.131l-1.777,1.94l-0.162,0.97l0.646,0.809l-0.646,2.586  l-2.264,0.485v1.132l0.809,2.425l-1.131,6.143l-1.617,4.042l0.646,4.688l0.485,1.131l-0.81,2.425l-0.322,0.808l-0.323,2.748  l3.557,5.981l2.91,6.466l1.455,4.85l-0.81,4.688l-0.97,5.981l-2.425,5.173l-0.324,2.748l-3.259,3.085l4.409-0.162l21.418-2.264  l7.277-0.987l0.097,1.667l6.853-1.213l10.298-1.503l3.854-0.461l0.139-0.587l0.162-1.455l2.102-3.718l2-1.738l-0.222-5.052  l1.597-1.597l1.091-0.343l0.222-3.557l1.536-3.031l1.051,0.606l0.162,0.646l0.809,0.162l1.939-0.97L985.859,339.237z   M855.491,273.213l0.716-0.581l2.749-0.809l3.557-2.263v-0.97l0.646-0.646l5.981-0.97l2.425-1.94l4.364-2.102l0.161-1.293  l1.939-2.91l1.778-0.808l1.294-1.778l2.263-2.263l4.365-2.425l4.688-0.485l1.132,1.132l-0.323,0.97l-3.718,0.97l-1.455,3.071  l-2.264,0.809l-0.484,2.425l-2.425,3.233l-0.324,2.586l0.809,0.485l0.971-1.132l3.557-2.91l1.294,1.293h2.263l3.233,0.97  l1.455,1.132l1.455,3.071l2.748,2.748l3.88-0.161l1.454-0.97l1.616,1.293l1.617,0.485l1.293-0.808h1.132l1.616-0.97l4.041-3.557  l3.396-1.131l6.628-0.323l4.526-1.94l2.587-1.293l1.455,0.162v5.658l0.483,0.323l2.91,0.808l1.939-0.485l6.144-1.617l1.132-1.131  l1.455,0.485v6.951l3.232,3.072l1.294,0.646l1.293,0.97l-1.293,0.323l-0.81-0.323l-3.718-0.485l-2.103,0.647l-2.264-0.162  l-3.233,1.455h-1.777l-5.819-1.293l-5.173,0.162l-1.94,2.586l-6.951,0.647l-2.425,0.808l-1.132,3.072l-1.293,1.131l-0.485-0.162  l-1.455-1.617l-4.525,2.425h-0.646l-1.132-1.617l-0.809,0.162l-1.939,4.365l-0.97,4.042l-3.183,7.001l-1.177-1.035l-1.371-1.031  l-1.941-10.288l-3.544-1.37l-2.053-2.286l-12.12-2.744l-2.854-1.029l-8.23-2.173l-7.891-1.143L855.491,273.213z\"/></a><a onmouseover=\"display(this)\" onmouseout=\"clearit(this)\" href=\"Wyoming.html\"><path id=\"WY\" sodipodi:nodetypes=\"ccccccccccccccccccc\" fill=\""+wy+"\" d=\"M642.252,305.776l-10.55-0.807l-32.088-3.295  l-16.231-2.058l-28.35-4.115l-19.89-2.972l-1.419,11.176l-3.839,24.26l-5.259,30.407l-1.53,10.516l-1.67,11.889l6.523,0.928  l25.88,2.5l20.569,2.307l36.783,4.115l23.821,2.86l4.504-44.192l1.44-25.377L642.252,305.776z\"/></a><a onmouseover=\"display(this)\" onmouseout=\"clearit(this)\" href=\"Montana.html\"><path id=\"MT\" sodipodi:nodetypes=\"cccccccccccccccccccccccccccccccccccccccccccccccccccccccc\" fill=\""+mt+"\" d=\"M644.671,284.274  l0.646-11.151l2.259-24.787c0.457-5.029,1.083-8.472,1.372-15.41l0.94-14.552l-30.676-2.808l-29.26-3.556l-29.261-4.042  l-32.332-5.335l-18.429-3.395l-32.725-6.933l-4.479,21.348l3.429,7.544l-1.372,4.572l1.829,4.573l3.201,1.372l4.621,10.77  l2.694,3.177l0.457,1.143l3.429,1.143l0.458,2.058l-7.087,17.604v2.515l2.516,3.201h0.914l4.801-2.972l0.686-1.143l1.601,0.686  l-0.229,5.258l2.744,12.574l2.972,2.515l0.914,0.686l1.829,2.286l-0.457,3.429l0.686,3.43l1.144,0.914l2.287-2.286h2.743l3.2,1.601  l2.516-0.915h4.114l3.658,1.6l2.744-0.457l0.457-2.972l2.972-0.686l1.372,1.372l0.458,3.201l1.779,1.365l1.534-11.565l20.691,2.972  l28.188,3.955l16.553,1.897l31.446,3.456l10.989,1.524l1.052-15.428L644.671,284.274z\"/></a><a onmouseover=\"display(this)\" onmouseout=\"clearit(this)\" href=\"Idaho.html\"><path id=\"ID\" sodipodi:nodetypes=\"cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc\" fill=\""+id+"\" d=\"  M428.979,338.609l4.427-17.502l4.344-17.718l1.372-4.229l2.516-5.944l-1.257-2.286l-2.516,0.114l-0.8-1.029l0.457-1.143l0.343-3.086  l4.458-5.487l1.829-0.458l1.143-1.143l0.571-3.201l0.915-0.686l3.887-5.83l3.886-4.344l0.229-3.772l-3.43-2.629l-1.314-4.401  l0.4-9.66l3.657-16.46l4.458-20.805l3.772-13.489l0.762-3.803l12.996,2.528l-4.158,21.508l2.948,7.705l-1.051,4.572l1.988,4.573  l3.201,1.692l4.46,9.807l2.695,3.818l0.618,1.143l3.429,1.143l0.458,2.539l-6.927,16.802l0.32,3.317l2.676,2.879l1.877,0.481  l4.801-3.614l0.365-0.501l0.155,0.847l0.253,4.135l2.583,12.895l3.454,2.676l0.434,0.846l2.149,2.447l-0.777,2.787l0.686,3.75  l1.945,0.915l2.126-1.645l2.583-0.481l3.36,1.601l2.516-0.594l3.794-0.16l3.979,1.6l2.744-0.297l0.938-2.33l2.491-1.649l0.73,1.693  l0.617,2.238l2.309,2.539l-3.772,23.981l-5.144,29.009l-4.16-0.319l-8.185-1.532l-9.807-1.829l-12.163-2.378l-12.528-2.504  l-8.482-1.84l-9.259-1.668l-9.235-1.783C427.509,338.616,435.972,340.113,428.979,338.609z\"/></a><a onmouseover=\"display(this)\" onmouseout=\"clearit(this)\" href=\"Washington.html\"><path id=\"WA\" sodipodi:nodetypes=\"ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccscccccc\" fill=\""+wa+"\" d=\"  M381.572,168.362l4.365,1.455l9.7,2.748l8.567,1.94l20.047,5.658l22.955,5.658l15.161,3.395l-1.004,3.884l-4.093,13.81  l-4.458,20.805l-3.177,16.14l-0.353,9.379l-13.181-3.894l-15.57-3.383l-13.667,0.596l-1.581-1.532l-5.326,1.897l-3.977-0.25  l-2.721-1.761l-1.579,0.525l-4.205-0.229l-1.875-1.372l-4.777-1.737l-1.442-0.207l-4.985-1.326l-1.783,1.508l-5.691-0.343  l-4.82-3.794l0.204-0.8l0.068-7.934l-2.125-3.887l-4.115-0.732l-0.365-2.354l-2.514-0.627l-2.882-0.535l-1.778,0.97l-2.264-2.91  l0.324-2.91l2.748-0.323l1.616-4.042l-2.587-1.132l0.162-3.718l4.365-0.646l-2.749-2.749l-1.455-7.113l0.646-2.91v-7.922  l-1.777-3.233l2.263-9.376l2.103,0.485l2.425,2.91l2.749,2.586l3.232,1.94l4.527,2.102l3.071,0.647l2.909,1.455l3.396,0.97  l2.263-0.162v-2.425l1.293-1.131l2.103-1.293l0.322,1.132l0.324,1.778l-2.264,0.485l-0.323,2.102l1.778,1.455l1.132,2.425  l0.646,1.94l1.455-0.162l0.162-1.293l-0.97-1.293l-0.485-3.233l0.808-1.778l-0.646-1.455v-2.263l1.778-3.556l-1.133-2.587  l-2.425-4.85l0.323-0.809L381.572,168.362z M372.116,174.341l2.021-0.162l0.484,1.374l1.536-1.617h2.345l0.809,1.536l-1.536,1.698  l0.646,0.808l-0.729,2.021l-1.374,0.404c0,0-0.889,0.081-0.889-0.242c0-0.323,1.455-2.586,1.455-2.586l-1.698-0.566l-0.323,1.455  l-0.728,0.647l-1.536-2.263L372.116,174.341z\"/></a><a onmouseover=\"display(this)\" onmouseout=\"clearit(this)\" href=\"Texas.html\"><path id=\"TX\" sodipodi:nodetypes=\"ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc\" fill=\""+tx+"\" d=\"  M645.053,495.373l22.69,1.087l31.094,1.143l-2.336,23.456l-0.297,18.153l0.068,2.081l4.344,3.818l1.736,0.822l1.81,0.253  l0.688-1.255l0.89,0.865l1.737,0.48l1.604-0.729l1.139,0.409l-0.297,3.405l4.275,1.03l2.676,0.821l3.954,0.525l2.193,1.829  l3.249-1.576l2.787,0.365l2.034,2.787l1.074,0.32l-0.16,1.965l3.089,1.168l2.768-1.805l1.509,0.364l2.354,0.16l0.433,1.872  l4.642,1.99l2.656-0.205l1.988-4.115h0.341l1.144,1.897l4.437,1.007l3.337,1.211l3.293,0.754l2.15-0.754l0.846-2.515h3.702  l1.896,0.754l3.064-1.576h0.661l0.364,1.119h4.275l2.403-1.256l1.668,0.297l1.416,1.872l2.88,1.669l3.521,1.075l2.743,1.418  l2.447,1.622l3.293-0.891l1.939,0.982l0.512,10.14l0.335,9.702l0.687,9.533l0.524,4.047l2.677,4.599l1.074,4.065l3.862,6.289  l0.549,2.88l0.526,1.007l-0.688,7.496l-2.649,4.388l0.957,2.86l-0.364,2.515l-0.847,7.316l-1.372,2.719l0.604,4.387l-5.665,1.585  l-9.861,4.526l-0.97,1.938l-2.587,1.94l-2.103,1.455l-1.293,0.809l-5.658,5.334l-2.748,2.103l-5.335,3.232l-5.658,2.425  l-6.305,3.396l-1.778,1.454l-5.819,3.557l-3.396,0.646l-3.88,5.497l-4.042,0.323l-0.97,1.939l2.264,1.939l-1.455,5.496l-1.293,4.526  l-1.132,3.88l-0.81,4.526l0.81,2.425l1.777,6.951l0.971,6.144l1.777,2.749l-0.97,1.453l-3.072,1.94l-5.657-3.88l-5.497-1.132  l-1.293,0.484l-3.232-0.646l-4.203-3.072l-5.173-1.131l-7.6-3.396l-2.102-3.88l-1.293-6.466l-3.233-1.94l-0.646-2.263l0.646-0.647  l0.323-3.395l-1.293-0.646l-0.646-0.97l1.293-4.365l-1.616-2.263l-3.232-1.294l-3.396-4.364l-3.557-6.629l-4.204-2.586l0.162-1.94  l-5.334-12.286l-0.81-4.202l-1.777-1.939l-0.162-1.455l-5.981-5.335l-2.586-3.071v-1.132l-2.586-2.102l-6.79-1.133l-7.437-0.646  l-3.071-2.265l-4.526,1.778l-3.557,1.455l-2.264,3.232l-0.97,3.72l-4.365,6.143l-2.425,2.425l-2.586-0.97l-1.778-1.132l-1.939-0.646  l-3.881-2.264v-0.646l-1.777-1.938l-5.173-2.103l-7.437-7.76l-2.263-4.688v-8.083l-3.233-6.466L599.809,621l-1.616-0.97  l-1.133-2.103l-5.011-2.102l-1.293-1.616l-7.113-7.922l-1.293-3.233l-4.688-2.263l-1.455-4.365l-2.586-2.909l-1.94-0.484  l-0.649-4.679l8.002,0.687l29.035,2.744l29.035,1.6l2.287-23.776l3.886-55.555l1.602-18.748l1.371,0.029 M745.229,729.322  l-0.566-7.112l-2.748-7.194l-0.564-7.032l1.535-8.244l3.313-6.871l3.477-5.415l3.151-3.557l0.646,0.242l-4.77,6.628l-4.365,6.548  l-2.021,6.628l-0.323,5.173l0.889,6.144l2.587,7.193l0.485,5.174l0.161,1.454L745.229,729.322z\"/></a><a onmouseover=\"display(this)\" onmouseout=\"clearit(this)\" href=\"California.html\"><path id=\"CA\" sodipodi:nodetypes=\"ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccscc\" fill=\""+ca+"\" d=\"  M424.74,548.754l3.815-0.489l1.485-2.011l0.732-1.941l-3.176-0.09l-1.1-1.765l0.778-1.715l-0.046-6.149l2.218-1.328l2.698-2.583  l0.411-4.915l1.646-3.497l1.943-2.104l3.269-1.714l1.279-0.73l0.756-1.482l-0.869-0.894l-0.96-1.511l-0.937-5.348l-2.904-5.236  l0.097-2.787l-2.201-3.248l-14.999-23.229l-19.433-28.715l-22.427-33.032l-12.702-19.545l1.797-7.208l6.812-25.949l8.116-31.436  l-12.365-3.337l-13.488-3.43l-12.574-4.115l-7.544-2.058l-11.431-2.972l-7.052-2.412l-1.58,4.725l-0.162,7.437l-5.173,11.801  l-3.07,2.587l-0.324,1.131l-1.778,0.809l-1.455,4.203l-0.809,3.233l2.749,4.203l1.617,4.203l1.131,3.557l-0.323,6.467l-1.778,3.071  l-0.646,5.82l-0.97,3.718l1.778,3.88l2.748,4.526l2.264,4.85l1.293,4.042l-0.323,3.233l-0.322,0.485v2.102l5.657,6.305l-0.484,2.425  l-0.646,2.264l-0.646,1.939l0.162,8.245l2.102,3.718l1.94,2.586l2.748,0.485l0.97,2.749l-1.132,3.557l-2.103,1.616h-1.131  l-0.809,3.88l0.484,2.91l3.233,4.365l1.616,5.334l1.455,4.688l1.293,3.071l3.396,5.82l1.455,2.587l0.484,2.91l1.617,0.97v2.425  l-0.809,1.94l-1.778,7.112l-0.485,1.939l2.426,2.748l4.202,0.484l4.527,1.778l3.88,2.102h2.91l2.91,3.071l2.586,4.85l1.131,2.265  l3.88,2.102l4.85,0.81l1.455,2.102l0.647,3.232l-1.455,0.646l0.323,0.97l3.232,0.81l2.748,0.161l2.91,4.688l3.88,4.203l0.808,2.263  l2.587,4.203l0.323,3.232v9.377l0.485,1.778l10.022,1.454l19.724,2.749L424.74,548.754z M336.793,499.036l1.293,1.535l-0.162,1.294  l-3.233-0.081l-0.566-1.213l-0.646-1.454L336.793,499.036z M338.732,499.036l1.212-0.646l3.557,2.102l3.072,1.212l-0.889,0.646  l-4.527-0.242l-1.616-1.616L338.732,499.036z M359.426,518.841l1.777,2.344l0.809,0.97l1.536,0.566l0.565-1.455l-0.97-1.778  l-2.667-2.021l-1.051,0.161V518.841L359.426,518.841z M357.971,527.488l1.777,3.152l1.213,1.939l-1.455,0.242l-1.293-1.213  c0,0-0.729-1.455-0.729-1.858s0-2.183,0-2.183L357.971,527.488z\"/></a><a onmouseover=\"display(this)\" onmouseout=\"clearit(this)\" href=\"Arizona.html\"><path id=\"AZ\" sodipodi:nodetypes=\"ccccccccccccccccccccccccccccccccccccccccccccccccccc\" fill=\""+az+"\" d=\"M425.746,549.5  l-2.627,2.158l-0.322,1.454l0.484,0.971l18.914,10.669l12.125,7.6l14.711,8.566l16.812,10.023l12.285,2.425l25.129,2.705  l2.53-12.507l3.753-27.243l6.965-52.881l4.258-30.966l-24.598-3.68l-27.207-4.573l-33.429-6.317l-2.922,18.092l-0.458,0.457  l-1.714,2.63l-2.516-0.114l-1.257-2.744l-2.744-0.343l-0.915-1.143h-0.914l-0.915,0.57l-1.942,1.028l-0.114,6.974l-0.229,1.716  l-0.57,12.573l-1.486,2.172l-0.571,3.314l2.743,4.916l1.258,5.829l0.8,1.029l1.029,0.57l-0.115,2.286l-1.6,1.372l-3.429,1.715  l-1.943,1.943l-1.486,3.656l-0.57,4.916l-2.858,2.743l-2.058,0.687l-0.114,5.829l-0.457,1.716l0.457,0.8l3.658,0.571l-0.571,2.743  l-1.486,2.172L425.746,549.5z\"/></a><a onmouseover=\"display(this)\" onmouseout=\"clearit(this)\" href=\"Nevada.html\"><path id=\"NV\" sodipodi:nodetypes=\"ccccccccccccccccccccccccccccccccccccc\" fill=\""+nv+"\" d=\"M428.657,339.572l20.98,4.511  l9.716,1.943l9.259,1.829l6.615,1.633l-0.56,5.865l-3.543,17.329l-4.093,19.98l-1.943,9.719l-2.172,13.281l-3.154,16.415  l-3.521,15.686l-1.968,10.181l-2.466,16.771l-0.457,1.099l-1.073,2.469l-1.873-0.114l-1.097-2.742l-2.743-0.505l-1.396-0.981  l-2.038,0.321l-0.915,0.73l-1.301,1.35l-0.436,6.975l-0.551,1.715l-0.411,12.093l-1.321,1.714l-1.876-2.262l-14.519-22.748  l-19.433-29.035l-22.748-33.836l-12.382-18.582l1.636-6.566l6.973-25.949l7.889-31.348l33.606,8.143l13.717,2.972\"/></a><a onmouseover=\"display(this)\" onmouseout=\"clearit(this)\" href=\"Utah.html\"><path id=\"UT\" sodipodi:nodetypes=\"ccccccccccccccccccccccccccc\" fill=\""+ut+"\" d=\"M540.971,471.307l-24.644-3.474l-26.563-4.893  l-33.827-6.02l1.588-9.157l3.201-15.203l3.314-16.575l2.172-13.603l1.943-8.917l3.772-20.461l3.544-17.49l1.113-5.573l12.718,2.258  l12.002,2.058l10.287,1.829l8.346,1.372l3.678,0.479l-1.485,10.63l-2.312,13.173l7.808,0.928l16.407,1.805l8.211,0.856l-2.13,21.967  l-3.201,22.566l-3.753,27.826l-1.666,11.107L540.971,471.307z\"/></a><a onmouseover=\"display(this)\" onmouseout=\"clearit(this)\" href=\"Colorado.html\"><path id=\"CO\" sodipodi:nodetypes=\"ccccccccccccccc\" fill=\""+co+"\" d=\"M666.62,418.796l1.44-21.282l-32.095-3.064l-24.464-2.7  l-37.265-4.115l-20.689-2.515l-2.63,22.176l-3.2,22.404l-3.754,27.986l-1.505,11.107l-0.251,2.764l33.927,3.795l37.74,4.267  l31.961,3.165l16.608,0.847\"/></a><a onmouseover=\"display(this)\" onmouseout=\"clearit(this)\" href=\"New%20Mexico.html\"><path id=\"NM\" sodipodi:nodetypes=\"ccccccccccccccccccccc\" fill=\""+nm+"\" d=\"M570.724,593.045l-0.65-6.123l8.645,0.524l29.516,3.064  l28.393,1.438l1.966-22.332l3.726-55.876l1.119-19.39l2.014,0.35l-0.014-11.074l-32.204-2.402l-36.938-4.428l-34.465-4.114  l-4.2,30.758l-6.965,53.202l-3.752,26.922l-2.049,13.309l15.46,1.989l1.293-10.022l16.65,2.586L570.724,593.045z\"/></a><a onmouseover=\"display(this)\" onmouseout=\"clearit(this)\" href=\"Oregon.html\"><path id=\"OR\" sodipodi:nodetypes=\"cccccccccccccccccccccccccccccccccccccccccccccccccccccccccc\" fill=\""+or+"\" d=\"M428.306,338.687  l4.298-17.901l4.665-17.879l1.051-4.229l2.354-5.623l-0.615-1.163l-2.516-0.046l-1.281-1.67l0.458-1.464l0.503-3.247l4.458-5.487  l1.829-1.1l1.143-1.143l1.486-3.566l4.047-5.669l3.564-3.862l0.229-3.451l-3.27-2.469l-1.209-4.51l-13.237-3.745l-15.09-3.543  l-15.432,0.114l-0.458-1.372l-5.487,2.058l-4.458-0.572l-2.4-1.6l-1.258,0.686l-4.687-0.229l-1.715-1.372l-5.258-2.058l-0.801,0.114  l-4.344-1.486l-1.943,1.829l-6.173-0.343l-5.943-4.115l0.686-0.8l0.229-7.773l-2.285-3.887l-4.115-0.572l-0.687-2.515l-2.354-0.466  l-5.798,2.059l-2.265,6.466l-3.232,10.023l-3.233,6.466l-5.011,14.064l-6.467,13.58l-8.083,12.61l-1.94,2.91l-0.808,8.568  l-1.293,5.981l2.708,3.527l6.729,2.251l11.592,3.293l7.866,2.539l12.414,3.634l13.328,3.59l13.168,3.565\"/></a><a onmouseover=\"display(this)\" onmouseout=\"clearit(this)\" href=\"North%20Dakota.html\"><path id=\"ND\" sodipodi:nodetypes=\"cccccccccccccccccccc\" fill=\""+nd+"\" d=\"M759.306,289.668l-0.365-7.496l-1.989-7.316  l-1.829-13.649l-0.457-9.831l-1.989-3.108l-1.601-5.351v-10.288l0.687-3.887l-2.115-5.499l-28.424-0.564l-18.592-0.646  l-26.512-1.293l-24.946-1.884l-1.261,14.23l-1.372,15.089l-2.259,24.947l-0.486,11.021l56.816,3.764L759.306,289.668z\"/></a><a onmouseover=\"display(this)\" onmouseout=\"clearit(this)\" href=\"South%20Dakota.html\"><path id=\"SD\" sodipodi:nodetypes=\"cccccccccccccccccccccccccccccccccccccccccc\" fill=\""+sd+"\" d=\"M760.797,365.181l-0.953-1.081  l-1.521-3.627l1.829-3.702l1.051-5.555l-2.583-2.058l-0.297-2.744l0.594-2.996l2.15-0.802l0.297-5.735l-0.068-30.086l-0.618-2.972  l-4.114-3.59l-0.982-1.989v-1.921l1.897-1.279l1.531-1.853l0.184-2.72l-57.384-1.6l-56.174-3.887l-0.767,5.279l-1.613,15.868  l-1.345,17.947l-1.601,24.597l16.027,1.029l19.638,1.143l17.993,1.303l23.776,1.304l10.744-0.778l2.86,2.286l4.319,2.973  l0.982,0.754l3.541-0.891l4.047-0.297l2.743-0.068l3.113,1.211l4.548,1.439l3.133,1.761l0.618,1.921l0.914,1.897l0.706-0.481  L760.797,365.181z\"/></a><a onmouseover=\"display(this)\" onmouseout=\"clearit(this)\" href=\"Nebraska.html\"><path id=\"NE\" sodipodi:nodetypes=\"ccccccccccccccccccccccccccccccccccccc\" fill=\""+ne+"\" d=\"M772.243,408.989l1.372,2.675  l0.093,2.126l2.354,3.727l2.72,3.151h-5.05l-43.482-0.938l-40.787-0.89l-21.19-0.961l1.072-21.327l-33.379-2.744l4.345-44.01  l15.546,1.029l20.118,1.143l17.832,1.143l23.777,1.144l10.745-0.458l2.058,2.286l4.801,2.972l1.145,0.915l4.344-1.372l3.887-0.458  l2.743-0.229l1.829,1.372l5.029,1.601l2.973,1.6l0.457,1.601l0.915,2.058h1.828l0.799,0.046l0.981,5.212l2.743,8.026l1.235,4.641  l2.126,3.818l0.524,4.938l1.439,4.275l0.55,6.47\"/></a><a onmouseover=\"display(this)\" onmouseout=\"clearit(this)\" href=\"Iowa.html\"><path id=\"IA\" sodipodi:nodetypes=\"cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc\" fill=\""+ia+"\" d=\"  M854.594,363.628l0.17,1.942l2.287,1.14l1.141,1.257l0.344,1.262l3.888,3.202l0.687,2.173l-0.8,2.862l-1.488,3.544l-0.8,2.742  l-2.173,1.603l-1.716,0.572l-5.484,1.485l-0.688,2.283l-0.799,2.285l0.572,1.372l1.716,1.714l-0.002,3.661l-2.169,1.601  l-0.459,1.487v2.517l-1.489,0.457l-1.714,1.37l-0.455,1.485l0.455,1.717l-1.374,1.205l-2.294-2.691l-1.483-2.626l-8.341,0.799  l-10.171,0.571l-25.036,0.688l-13.035,0.229l-9.374,0.229l-1.315,0.122l-1.653-4.472l-0.229-6.63l-1.601-4.115l-0.688-5.258  l-2.286-3.658l-0.914-4.801l-2.743-7.544l-1.144-5.373l-1.372-2.172l-1.6-2.744l1.828-4.344l1.371-5.716l-2.743-2.058l-0.457-2.743  l0.914-2.515h1.715h11.546l49.61-0.686l19.877-0.686l1.852,2.747l1.832,2.622l0.455,0.804l-1.83,2.749l0.455,4.222l2.516,3.886  l2.969,1.824l2.405,0.23L854.594,363.628z\"/></a><a onmouseover=\"display(this)\" onmouseout=\"clearit(this)\" href=\"Mississippi.html\"><path id=\"MS\" sodipodi:nodetypes=\"ccccccccccccccccccccccccccccccccccccccccccccccccccccc\" fill=\""+ms+"\" d=\"M912.559,628.97  l-0.254,1.256h-5.174l-1.454-0.81l-2.103-0.322l-6.79,1.939l-1.778-0.809l-2.587,4.203l-1.103,0.777l-1.123-2.488l-1.145-3.887  l-3.43-3.2l1.144-7.545l-0.686-0.914l-1.829,0.229l-8.23,0.686l-24.233,0.688l-0.457-1.602l0.686-8.002l3.431-6.173l5.258-9.146  l-0.914-2.058h1.143l0.688-3.201l-2.286-1.829l0.229-1.829l-2.058-4.572l-0.286-5.344l1.372-2.658l-0.4-4.344l-1.371-2.972  l1.371-1.372l-1.371-2.059l0.457-1.829l0.914-6.173l2.973-2.743l-0.687-2.058l3.657-5.259l2.743-0.914v-2.516l-0.686-1.372  l2.743-5.258l2.743-1.144l0.107-3.412l8.675-0.077l24.088-1.94l4.58-0.229l0.009,6.372l0.161,16.65l-0.808,31.038l-0.162,14.063  l2.748,18.754L912.559,628.97z\"/></a><a onmouseover=\"display(this)\" onmouseout=\"clearit(this)\" href=\"Indiana.html\"><path id=\"IN\" sodipodi:nodetypes=\"ccccccccccccccccccccccccccccccccccccccccccccccccccc\" fill=\""+in+"\" d=\"M906.421,462.854  l0.063-2.858l0.485-4.525l2.264-2.91l1.777-3.88l2.587-4.203l-0.484-5.82l-1.778-2.748l-0.323-3.232l0.809-5.496l-0.484-6.952  l-1.294-16.004l-1.293-15.358l-0.971-11.72l3.071,0.889l1.454,0.97l1.133-0.323l2.102-1.94l2.829-1.617l5.093-0.162l21.986-2.263  l5.574-0.533l1.505,15.957l4.251,36.84l0.599,5.771l-0.372,2.263l1.229,1.795l0.097,1.373l-2.521,1.601l-3.54,1.551l-3.202,0.55  l-0.599,4.867l-4.574,3.312l-2.797,4.01l0.323,2.377l-0.581,1.534h-3.326l-1.586-1.617l-2.493,1.263l-2.684,1.503l0.161,3.055  l-1.193,0.258l-0.468-1.018l-2.167-1.503l-3.25,1.341l-1.552,3.006l-1.438-0.809l-1.455-1.6l-4.465,0.485l-5.593,0.97  L906.421,462.854z\"/></a><a onmouseover=\"display(this)\" onmouseout=\"clearit(this)\" href=\"Illinois.html\"><path id=\"IL\" sodipodi:nodetypes=\"ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc\" fill=\""+il+"\" d=\"  M905.805,463.602v-3.605l0.258-4.866l2.377-3.138l1.778-3.766l2.587-3.863l-0.372-5.252l-2.005-3.542l-0.098-3.347l0.695-5.271  l-0.825-7.178l-1.066-15.778l-1.294-15.017l-0.922-11.639l-0.271-0.921l-0.81-2.587l-1.293-3.718l-1.617-1.778l-1.454-2.587  l-0.232-5.489l-9.903,1.312l-27.206,1.715l-8.688-0.429l0.229,2.372l2.286,0.686l0.915,1.143l0.457,1.829l3.887,3.429l0.686,2.286  l-0.686,3.429l-1.829,3.658l-0.688,2.515l-2.285,1.829l-1.829,0.686l-5.259,1.372l-0.686,1.829l-0.688,2.058l0.688,1.372l1.828,1.6  l-0.229,4.114l-1.828,1.602l-0.687,1.601v2.743l-1.829,0.457l-1.601,1.144l-0.229,1.372l0.229,2.059l-1.715,1.313l-1.029,2.801  l0.457,3.658l2.287,7.316l7.315,7.545l5.486,3.658l-0.229,4.344l0.914,1.372l6.4,0.457l2.743,1.372l-0.686,3.657l-2.286,5.944  l-0.687,3.201l2.286,3.886l6.401,5.258l4.571,0.687l2.059,5.029l2.058,3.2l-0.914,2.974l1.6,4.114l1.829,2.059l1.944-0.792  l0.687-2.164l2.037-1.438l3.236-1.101l3.088,1.18l2.876,1.066l0.791-0.21l-0.065-1.241l-1.065-2.767l0.438-2.377l2.28-1.567  l2.358-0.987l1.163-0.42l-0.582-1.324l-0.76-2.167l1.245-1.262L905.805,463.602z\"/></a><a onmouseover=\"display(this)\" onmouseout=\"clearit(this)\" href=\"Minnesota.html\"><path id=\"MN\" sodipodi:nodetypes=\"cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc\" fill=\""+mn+"\" d=\"  M759.879,290.471l-0.457-8.459l-1.829-7.316l-1.829-13.489l-0.457-9.831l-1.829-3.429l-1.602-5.03v-10.288l0.688-3.887l-1.821-5.452  l30.133,0.035l0.323-8.245l0.646-0.162l2.264,0.485l1.939,0.809l0.81,5.497l1.453,6.143l1.617,1.616h4.851l0.322,1.455l6.306,0.323  v2.102h4.85l0.323-1.293l1.132-1.132l2.264-0.646l1.293,0.97h2.91l3.88,2.587l5.335,2.425l2.425,0.485l0.484-0.97l1.455-0.485  l0.484,2.91l2.587,1.293l0.484-0.485l1.293,0.162v2.102l2.587,0.97h3.071l1.616-0.809l3.233-3.233l2.586-0.485l0.809,1.778  l0.485,1.293h0.97l0.971-0.808l8.892-0.323l1.778,3.071h0.646l0.714-1.084l4.439-0.371l-0.612,2.28l-3.938,1.837l-9.246,4.061  l-4.773,2.007l-3.071,2.587l-2.425,3.557l-2.265,3.879l-1.777,0.809l-4.526,5.011l-1.293,0.162l-3.842,2.934l-2.816,3.161  l-0.229,2.97l0.227,7.778l-1.597,1.6l-5.259,4.114l-1.832,5.717l2.519,3.647l0.458,2.52l-1.147,2.974l-0.228,3.659l0.458,7.084  l3.426,4.107h2.976l2.511,2.293l3.201,1.365l3.659,5.035l7.088,5.023l1.83,2.062l0.234,5.502l-20.588,0.686l-60.249,0.459  l-0.339-35.677l-0.457-2.972l-4.114-3.429l-1.145-1.829v-1.601l2.058-1.6l1.372-1.372L759.879,290.471z\"/></a><a onmouseover=\"display(this)\" onmouseout=\"clearit(this)\" href=\"Wisconsin.html\"><path id=\"WI\" sodipodi:nodetypes=\"cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc\" fill=\""+wi+"\" d=\"  M900.94,359.181l0.37-2.97l-1.616-4.527l-0.646-6.143l-1.133-2.425l0.971-3.072l0.809-2.91l1.455-2.586l-0.647-3.395l-0.646-3.557  l0.484-1.778l1.939-2.425l0.162-2.748l-0.81-1.293l0.646-2.586l0.484-3.233l2.748-5.658l2.91-6.79l0.161-2.263l-0.323-0.97  l-0.808,0.485l-4.203,6.305l-2.749,4.042l-1.939,1.778l-0.809,2.263l-1.455,0.808l-1.131,1.94l-1.455-0.323l-0.162-1.778  l1.294-2.425l2.102-4.688l1.777-1.617l1.102-2.292l-1.631-0.905l-1.371-1.372l-1.601-10.288l-3.658-1.144l-1.371-2.286  l-12.574-2.743l-2.516-1.143l-8.23-2.287l-8.229-1.143l-4.17-5.405l-0.529,1.261l-1.132-0.162l-0.646-1.132l-2.748-0.808  l-1.132,0.162l-1.778,0.97l-0.97-0.646l0.646-1.94l1.939-3.071l1.132-1.132l-1.938-1.455l-2.103,0.808l-2.91,1.94l-7.437,3.233  l-2.91,0.646l-2.909-0.485l-0.982-0.878l-2.116,2.835l-0.229,2.744v8.459l-1.145,1.6l-5.258,3.887l-2.286,5.944l0.457,0.229  l2.516,2.058l0.686,3.201l-1.829,3.201v3.887l0.458,6.63l2.972,2.972h3.431l1.827,3.201l3.431,0.458l3.887,5.715l7.088,4.115  l2.057,2.744l0.915,7.43l0.687,3.315l2.286,1.601l0.229,1.372l-2.057,3.429l0.229,3.201l2.515,3.887l2.516,1.143l2.972,0.458  l1.343,1.38h9.174l26.066-1.487L900.94,359.181z\"/></a><a onmouseover=\"display(this)\" onmouseout=\"clearit(this)\" href=\"Missouri.html\"><path id=\"MO\" sodipodi:nodetypes=\"ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc\" fill=\""+mo+"\" d=\"  M843.788,411.526l-2.521-3.087l-1.144-2.286l-7.772,0.687l-9.831,0.457l-25.377,0.914l-13.488,0.229l-7.888,0.115l-2.286,0.113  l1.257,2.516l-0.229,2.286l2.516,3.887l3.087,4.115l3.086,2.742l2.286,0.229l1.372,0.915v2.972l-1.829,1.602l-0.457,2.285  l2.058,3.431l2.515,2.972l2.516,1.829l1.372,11.66l-0.687,35.322l0.229,4.688l0.457,5.384l23.434-0.117l23.206-0.686l20.805-0.802  l11.655-0.229l2.169,3.426l-0.685,3.309l-3.088,2.401l-0.572,1.838l5.379,0.457l3.896-0.686l1.718-5.494l0.651-5.856l2.317-2.024  l1.713-1.486l2.058-1.03l0.114-2.859l0.574-1.715l-1.031-1.748l-2.745,0.145l-2.169-2.625l-1.374-4.229l0.803-2.52l-1.944-3.428  l-1.831-4.576l-4.799-0.799l-6.97-5.6l-1.719-4.112l0.799-3.201l2.061-6.059l0.459-2.863l-1.949-1.031l-6.855-0.798l-1.027-1.712  l-0.111-4.23l-5.487-3.431l-6.976-7.771l-2.286-7.315l-0.23-4.226L843.788,411.526z\"/></a><a onmouseover=\"display(this)\" onmouseout=\"clearit(this)\" href=\"Arkansas.html\"><path id=\"AR\" sodipodi:nodetypes=\"ccccccccccccccccccccccccccccccccccccccccccccc\" fill=\""+ar+"\" d=\"M878.951,506.952l-3.848,0.938  l-6.173-0.457l0.687-2.972l3.2-2.744l0.457-2.286l-1.828-2.973l-10.975,0.457l-20.806,0.915l-23.318,0.687l-23.319,0.457  l1.601,6.857v8.23l1.372,10.975l0.229,37.837l2.285,1.943l2.973-1.372l2.742,1.144l0.432,10.323l22.886-0.143l18.864-0.802  l10.121-0.196l1.146-2.092l-0.286-3.55l-1.826-2.972l1.601-1.485l-1.601-2.512l0.686-2.51l1.368-5.605l2.519-2.062l-0.687-2.284  l3.657-5.372l2.744-1.368l-0.113-1.494l-0.346-1.825l2.855-5.599l2.403-1.257l0.384-3.429l1.771-1.241l0.856-4.233l-1.342-4.012  l4.041-2.377l0.551-2.019l1.235-4.269L878.951,506.952z\"/></a><a onmouseover=\"display(this)\" onmouseout=\"clearit(this)\" href=\"Oklahoma.html\"><path id=\"OK\" sodipodi:nodetypes=\"ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc\" fill=\""+ok+"\" d=\"  M663.343,484.57l-10.688-0.457l-6.43-0.484l0.257,0.198l-0.704,10.423l21.965,1.406l32.056,1.304l-2.335,24.419l-0.457,17.832  l0.229,1.602l4.344,3.658l2.058,1.143l0.688-0.229l0.686-2.058l1.371,1.829h2.06v-1.371l2.742,1.371l-0.457,3.887l4.115,0.229  l2.515,1.145l4.115,0.686l2.515,1.829l2.286-2.058l3.431,0.686l2.515,3.431h0.914v2.285l2.286,0.687l2.286-2.286l1.828,0.687h2.517  l0.914,2.516l4.801,1.829l1.372-0.688l1.828-4.115h1.144l1.144,2.059l4.115,0.687l3.658,1.371l2.972,0.915l1.829-0.915l0.686-2.516  h4.345l2.058,0.915l2.744-2.058h1.143l0.688,1.6h4.113l1.602-2.058l1.829,0.458l2.058,2.515l3.201,1.829l3.2,0.914l1.94,1.119  l-0.389-37.218l-1.372-10.975l-0.161-8.872l-1.439-6.538l-0.777-7.18l-0.068-3.815l-12.137,0.318l-46.41-0.457l-45.038-2.059  L663.343,484.57z\"/></a><a onmouseover=\"display(this)\" onmouseout=\"clearit(this)\" href=\"Kansas.html\"><path id=\"KS\" sodipodi:nodetypes=\"ccccccccccccccccccccc\" fill=\""+ks+"\" d=\"M791.381,487.13l-12.618,0.205l-46.09-0.457  l-44.558-2.059l-24.63-1.258l4.145-64.72l21.832,0.8l40.468,1.372l44.124,0.458h5.096l3.247,3.225l2.768,0.229l0.89,1.074v2.01  l-1.829,1.601l-0.457,2.606l2.22,3.591l2.515,3.133l2.515,1.989l1.052,11.178L791.381,487.13z\"/></a><a onmouseover=\"display(this)\" onmouseout=\"clearit(this)\" href=\"Louisiana.html\"><path id=\"LA\" sodipodi:nodetypes=\"cccccccccccccccccccccccccccccccccccccccccccccccccscccccccccccccccccccccccccccccscccccccccccccccccccccccccccc\" fill=\""+la+"\" d=\"  M890.201,634.994l-1.028-2.615l-1.145-3.094l-3.314-3.541l0.915-6.75l-0.117-1.142l-1.263,0.342l-8.229,0.913l-25.028,0.459  l-0.685-2.396l0.912-8.456l3.315-5.944l5.031-8.691l-0.573-2.397l1.256-0.682l0.459-1.952l-2.286-2.056l-0.111-1.942l-1.831-4.346  l-0.456-5.941l-9.725,0.113l-19.205,0.915l-22.205,0.028l0.029,9.573l0.686,9.373l0.687,3.888l2.516,4.114l0.914,5.029l4.344,5.487  l0.229,3.199l0.687,0.688l-0.688,8.459l-2.972,5.029l1.601,2.058l-0.687,2.515l-0.687,7.316l-1.371,3.2l0.122,3.616l4.688-1.521  l8.083-0.323l10.346,3.557l6.467,1.132l3.718-1.455l3.233,1.133l3.233,0.97l0.808-2.103l-3.232-1.132l-2.587,0.485l-2.748-1.617  c0,0,0.161-1.293,0.81-1.455c0.646-0.161,3.07-0.97,3.07-0.97l1.778,1.455l1.778-0.971l3.231,0.646l1.455,2.425l0.324,2.264  l4.525,0.323l1.778,1.778l-0.81,1.615l-1.293,0.81l1.616,1.615l8.406,3.558l3.557-1.293l0.97-2.426l2.587-0.646l1.778-1.455  l1.293,0.971l0.809,2.91l-2.264,0.808l0.646,0.646l3.396-1.293l2.263-3.396l0.81-0.484l-2.103-0.323l0.81-1.616l-0.162-1.455  l2.102-0.485l1.132-1.293l0.646,0.809c0,0-0.161,3.071,0.646,3.071c0.81,0,4.203,0.646,4.203,0.646l4.042,1.938l0.97,1.455h2.91  l1.132,0.972l2.263-3.072v-1.455h-1.293l-3.396-2.748l-5.819-0.81l-3.232-2.263l1.132-2.748l2.263,0.323l0.162-0.646l-1.778-0.971  v-0.484h3.233l1.777-3.071l-1.293-1.939l-0.323-2.748l-1.455,0.161l-1.939,2.102l-0.646,2.587l-3.07-0.646l-0.972-1.778l1.778-1.939  l2.021-1.777L890.201,634.994z\"/></a><a onmouseover=\"display(this)\" onmouseout=\"clearit(this)\" href=\"Virginia.html\"><path id=\"VA\" sodipodi:nodetypes=\"ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc\" fill=\""+va+"\" d=\"  M1116.905,431.245l-0.144-1.946l6.452-2.551l-0.771,3.219l-2.92,3.778l-0.418,4.586l0.462,3.392l-1.828,4.978l-2.164,1.916  l-1.472-4.641l0.446-5.449l1.587-4.183L1116.905,431.245z M1119.187,459.547l-58.175,12.574l-37.428,5.279l-6.679-0.375  l-2.585,1.927l-7.339,0.222l-8.382,0.978l-8.928,0.951l8.48-4.948l-0.013-2.074l1.521-2.146l10.553-11.501l3.947,4.478l3.783,0.964  l2.543-1.14l2.236-1.312l2.537,1.345l3.914-1.429l1.876-4.557l2.603,0.54l2.854-2.131l1.799,0.493l2.827-3.677l0.349-2.083  l-0.964-1.275l1.003-1.867l5.274-12.277l0.615-5.734l1.229-0.523l2.179,2.443l3.936-0.302l1.93-7.572l2.794-0.562l1.05-2.741  l2.58-2.347l1.268-2.342l1.504-3.354l0.085-5.066l9.822,3.822c0.681,0.341,0.654-4.783,0.654-4.783l4.051,1.377l-0.462,2.629  l8.156,2.938l1.293,1.794l-0.868,3.683l-1.264,1.325l-0.507,1.746l0.494,2.403l1.959,1.278l3.918,1.444l2.949,0.969l4.855,0.941  l2.152,2.088l3.189,0.402l0.868,1.2l-0.438,4.689l1.373,1.104l-0.479,1.931l1.229,0.79l-0.222,1.385l-2.694-0.095l0.089,1.616  l2.281,1.543l0.121,1.412l1.772,1.785l0.491,2.524l-2.553,1.381l1.571,1.494l5.801-1.687L1119.187,459.547z\"/></a><a onmouseover=\"display(this)\" onmouseout=\"clearit(this)\" href=\"District%20of%20Columbia.html\"><path id=\"DC\" sodipodi:nodetypes=\"cccccc\" fill=\""+dc+"\" d=\"M1089.757,415.844l-1.077-1.638l-1.015-0.842l1.101-1.616l2.231,1.512  L1089.757,415.844z\"/></a></svg>");
page.println("</div>");
page.println("<table id=\"table\">");
  for (int i=0; i<13; i++) {
    page.println("<tr>");
    for (int t=0; t<4; t++) {
      if ((4*i+t)<states.length) {
        page.println("<td><a href=\""+states[4*i+t]+".html\">"+states[4*i+t]+"</a></td>");
      }
    }
    page.println("</tr>");
  }
  page.println("</table><iframe src=\"\" id=\"abc\" ></iframe>");
  page.println("<div id=\"key\"><div style=\"background:#acd8fd;z-index:10;  position: absolute; top:0;\"><canvas id=\"colorMeter\" width=\"280\" height=\"100\" style=\"border:1px solid #000000;\">"+
"</canvas></div>"+"<div style=\"background:#000000;z-index:15; position: absolute; top:70; \"><canvas id=\"ontop\" width=\"280\" height=\"30\" style=\"border:1px solid #000000;\">"+
"</canvas></div></div>");
page.println(
"<script>"+
"var c = document.getElementById(\"colorMeter\");");
for (int num=0; num<281; num++){
int r=255-num;
int g=0;
int b=num;
if (num%50==0){r=255; g=255; b=255;}
page.println("var l"+num+"l = c.getContext(\"2d\");"+
"l"+num+"l.beginPath();"+
"l"+num+"l.moveTo("+num+",0);"+
"l"+num+"l.lineTo("+num+",70);"+
"l"+num+"l.strokeStyle=\"rgb("+r+","+g+","+b+")\";"+
"l"+num+"l.stroke();");
}
page.println(""+
"var canvas = document.getElementById(\"ontop\");"+
"var t = canvas.getContext(\"2d\");"+
"t.font = \"10px Times New Roman\";"+
"t.fillStyle = \"white\";"+
"t.textAlign = \"center\";"+
"t.fillText(\"0%\", 10, 10);"+
"var p = canvas.getContext(\"2d\");"+
"p.font = \"10px Times New Roman\";"+
"p.fillStyle = \"white\";"+
"p.textAlign = \"center\";"+
"p.fillText(\"50%\", 50, 10);"+
"var s = canvas.getContext(\"2d\");"+
"s.font = \"10px Times New Roman\";"+
"s.fillStyle = \"white\";"+
"s.textAlign = \"center\";"+
"s.fillText(\"100%\", 100, 10);"+
"var q = canvas.getContext(\"2d\");"+
"q.font = \"10px Times New Roman\";"+
"q.fillStyle = \"white\";"+
"q.textAlign = \"center\";"+
"q.fillText(\"150%\", 150, 10);"+
"var n = canvas.getContext(\"2d\");"+
"n.font = \"10px Times New Roman\";"+
"n.fillStyle = \"white\";"+
"n.textAlign = \"center\";"+
"n.fillText(\"200%\", 200, 10);"+
"var e = canvas.getContext(\"2d\");"+
"e.font = \"10px Times New Roman\";"+
"e.fillStyle = \"white\";"+
"e.textAlign = \"center\";"+
"e.fillText(\"250%\", 250, 10);"+
"var v = canvas.getContext(\"2d\");"+
"v.font = \"10px Times New Roman\";"+
"v.fillStyle = \"white\";"+
"v.textAlign = \"center\";"+
"v.fillText(\"Percentage increase in vacant homes\", 128, 23);");
page.println("</script>");
  page.println("</body></html>");
  page.flush();
  page.close();

  /*save("map.png");*/
  println("done");
}