import controlP5.*;
import processing.serial.*;

PFont font1;
PFont font2;
ControlP5 cp5;

Timer startTimer;
float time;
Button submitbutton;

Serial myport;

Textarea console;
Chart heatingChart;
Chart StirringChart;
Chart pHChart;

void setup(){
    size(1400,800);
    font1 = loadFont("ComicSansMS-Bold-40.vlw");
    font2 = loadFont("Serif-20.vlw");
    myport = new Serial(this, "/dev/cu.usbmodemM43210051", 9600);
    //myport.bufferUntil('\n');
    startTimer = new Timer(0);
    cp5 = new ControlP5(this);
    textFont(font1);
    // Input text field and submission button
    cp5.addTextfield("pH").setPosition(50,180).setSize(200,50).setAutoClear(false).setFont(font2);
    cp5.addTextfield("Stirring").setPosition(50,280).setSize(200,50).setAutoClear(false).setFont(font2);
    cp5.addTextfield("Heating").setPosition(50,380).setSize(200,50).setAutoClear(false).setFont(font2);
    cp5.addButton("pHSubmit").setPosition(150,180).setSize(120,50).setFont(font2);
    cp5.addButton("StirSubmit").setPosition(150,280).setSize(120,50).setFont(font2);
    cp5.addButton("TempSubmit").setPosition(150,380).setSize(120,50).setFont(font2);
    
    //concole
    console = cp5.addTextarea("console")
                 .setPosition(500, 20)
                 .setSize(400, 400)
                 .setCaptionLabel("")
                 .setFont(font2)
                 .setColorBackground(100)
                 .scroll(1)
                 .hideScrollbar();
    
    //heating chart
    heatingChart = cp5.addChart("temperatureChart")
                          .setPosition(20, 500)
                          .setSize(400, 400)
                          .setRange(0, 40)     //nead change
                          .setView(Chart.LINE)
                          .setCaptionLabel("")
                          .setStrokeWeight(10);
    heatingChart.addDataSet("Heating");
    heatingChart.setData("Heating", new float[100]);
    
    //stirring chart
    StirringChart = cp5.addChart("StirringChart")
                          .setPosition(450, 500)
                          .setSize(400, 400)
                          .setRange(0, 3000)    // nead change
                          .setView(Chart.LINE)
                          .setCaptionLabel("")
                          .setStrokeWeight(10);
    StirringChart.addDataSet("Stirring");
    StirringChart.setData("Stirring", new float[100]);
    
    //stirring chart
    pHChart = cp5.addChart("pHChart")
                          .setPosition(880, 500)
                          .setSize(400, 400)
                          .setRange(0, 14)     //nead change
                          .setView(Chart.LINE)
                          .setCaptionLabel("")
                          .setStrokeWeight(1.5)
                          .setColorCaptionLabel(0);
    pHChart.addDataSet("pH");
    pHChart.setData("pH", new float[100]);
  
}

void addConsoleMsg (String newMsg) {
    String s = console.getText();
    s += newMsg + "\n";
    console.setText(s);
}

void draw(){
    background(15);
    text("Bio Reactor CS-EEE-7",20,100);
    startTimer.countup();
    text(startTimer.getTime(),100,50);
    text("Heating", 20, 490);
    text("Stirring", 450, 490);
    text("pH", 880, 490);
    
    getdata();
}

void pHSubmit(){
    String text = cp5.get(Textfield.class,"pH").getText();
    myport.write("phset"+ text + "\n");
    addConsoleMsg("Set pH to " + text);
}

void StirSubmit(){
    String text = cp5.get(Textfield.class,"Stirring").getText();
    myport.write("Stset"+text +"\n");
    addConsoleMsg("Set Stirring to " + text);
}

void TempSubmit(){
    String text = cp5.get(Textfield.class,"Heating").getText();
    myport.write("Teset"+text +"\n");
    addConsoleMsg("Set temperature to " + text);
}

void getdata(){
      if(myport.available()>0){
      String data = trim(myport.readStringUntil('\n'));
      println(data);
      if(data!= null && data.length()>4){
      if(data.substring(0,4).equals("temp")){
        addConsoleMsg("Current temperature is " + data.substring(4));  
        heatingChart.push("Heating", float(data.substring(4)));
      }else if(data.substring(0,4).equals("phhh")){
        addConsoleMsg("Current pH is " + data.substring(4)); 
        pHChart.push("pH", float(data.substring(4)));
      }else if(data.substring(0,4).equals("stir")){
        addConsoleMsg("Current stirring speed is " + data.substring(4)); 
        StirringChart.push("Stirring", float(data.substring(4)));
      }
      }
      }
}

void serialEvent(Serial myport) {
if(myport.available()>0){
      String data = trim(myport.readStringUntil('\n'));
      println(data);
      if(data!= null && data.length()>4){
      if(data.substring(0,4).equals("temp")){
        addConsoleMsg("Current temperature is " + data.substring(4));  
        heatingChart.push("Heating", float(data.substring(4)));
      }else if(data.substring(0,4).equals("phhh")){
        addConsoleMsg("Current pH is " + data.substring(4)); 
        pHChart.push("pH", float(data.substring(4)));
      }else if(data.substring(0,4).equals("stir")){
        addConsoleMsg("Current stirring speed is " + data.substring(4)); 
        StirringChart.push("Stirring", float(data.substring(4)));
      }
      }
}
myport.write("1\n"); 
}
