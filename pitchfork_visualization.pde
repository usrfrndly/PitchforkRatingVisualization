
/*

/*
Dataset downloaded from "Pitchfork // A Statistical Look at Their Ratings"
http://www.parttimemusic.com/2010/02/25/pitchfork-a-statistical-look-at-their-ratings/
 */


import processing.core.*;

//import library to import data from Excel file
import de.bezier.data.*;

  XlsReader reader;

  float plotX1, plotY1;
  float plotX2, plotY2;
  float labelX, labelY;
  String title;

  int rowCount;

  int column = 1;

  float ratingsMin = 0.0;
  float ratingsMax = 10.0;
  float freqMin = 0.0;
  float freqMax = 52.0;

  float[] ratings;
  float[] frequency;


  double ratingInterval = 0.5;
  float frequencyInterval = 4.0;

  PFont titleFont, smallFont; 
      PImage myImage;


  public void setup() {
    reader = new XlsReader( this, "Pitchfork_List.xls" );
    reader.firstRow();

    size( 800, 400 );
      smooth();
      //noLoop();
      titleFont = loadFont("Helvetica-22.vlw");
      smallFont = loadFont("Helvetica-12.vlw");
      textFont(smallFont);



    // Corners of the plotted time series
    plotX1 = 40; 
    plotX2 = width - 40;
    labelX = 50;
    plotY1 = 60;
    plotY2 = height - 60;
    labelY = height - 25;

     myImage = loadImage("pitchfork-logo.png");

    rowCount = reader.getLastRowNum()-1; 
    println("rowCount" + rowCount);
    ratings = new float[rowCount];
    frequency = new float[rowCount];
    title = "2010 Pitchfork Reviews";
    for( int i = 0; i < rowCount; i++){
      reader.nextRow();
      ratings[i] = reader.getFloat(); //rating
      reader.nextCell();
      frequency[i] = reader.getFloat(); //frequency 
    }
  

  }


  public void draw() {
      background(255);
    rectMode(CORNERS);
      textFont(smallFont);

    rect(plotX1, plotY1, plotX2, plotY2);
    reader.firstCell();

    drawTitle();
    drawAxisLabels();
    drawRatingsLabels();
    drawFrequencyLabels();

    stroke(0);
    noFill();
    strokeWeight(2);
    drawDataLine();  
    drawDataHighlight();
    smooth();  

  }





  void drawRatingsLabels() {
    fill(125);
    textAlign(CENTER);

    // Use thin, gray lines to draw the grid
    stroke(125);
    strokeWeight(1);

    for (int i = 0; i < rowCount; i++) {
      if (ratings[i] % ratingInterval == 0) {
        float x = map(ratings[i], ratingsMin, ratingsMax, plotX1, plotX2);
        text(String.format("%.1f", ratings[i]), x, plotY2 + textAscent() + 10);
        line(x, plotY1, x, plotY2);
      }
    }    
  }

  void drawAxisLabels() {
    fill(color(200,80,80,200));
     textFont(smallFont);

    textAlign(CENTER);
    text("Album Rating (out of 10.0)", (plotX2 - plotX1)/2, labelY);
    
    textAlign(CENTER,BOTTOM);
  float x = 15;
  float y = 200;
  pushMatrix();
    translate(x,y);
      rotate(-HALF_PI);
    text("Total occurances of rating in 2010", 0, 0);
      popMatrix();

  }

  void drawTitle() {
    fill(color(200,80,80,255));
    textAlign(LEFT);
      textFont(titleFont);

    text(title, plotX1, plotY1 - 20);
  }
  
  void drawFrequencyLabels() {
    fill(125);
  textAlign(RIGHT);

    stroke(125);
    strokeWeight(1);
    for (float v = freqMin; v <= freqMax; v += frequencyInterval) {
      if (v % frequencyInterval == 0) {     // If a tick mark
        float y = map(v, freqMin, freqMax, plotY2, plotY1);  
        float textOffset = textAscent()/2;  // Center vertically
        if (v == freqMin) {
          textOffset = 0;                   // Align by the bottom
        } else if (v == freqMax) {
          textOffset = textAscent();        // Align by the top
        }
        text(floor(v), plotX1-4 , y + textOffset);
        line(plotX1, y, plotX1 + 4, y);     // Draw major tick
      } 
    }
  }
  void drawDataPoints() {
    reader.firstRow();
      for (int i = 0; i < rowCount; i++) {
        float x = map(ratings[i], ratingsMin, ratingsMax, plotX1, plotX2);
        float y = map(frequency[i], freqMin, freqMax, plotY2, plotY1);
        point(x, y);
      }
     
  }

  void drawDataLine() {  
    beginShape();
      for (int i = 0; i < rowCount; i++) {

        println("row: "+ (i) + " ratings[i]: " +ratings[i] + " frequency[i]: " +frequency[i]);
        float x = map(ratings[i], ratingsMin, ratingsMax, plotX1, plotX2);
        float y = map(frequency[i], freqMin, freqMax, plotY2, plotY1);      
        vertex(x, y);
      }
    endShape();

  }


  void drawDataHighlight() {
      for (int i = 0; i < rowCount; i++) {
        float x = map(ratings[i], ratingsMin, ratingsMax, plotX1, plotX2);
        float y = map(frequency[i], freqMin, freqMax, plotY2, plotY1);      
        if (dist(mouseX, mouseY, x, y) < 3) {
          //strokeWeight(10);
                    stroke(0);

          //point(x, y);
          image(myImage, x  , y - myImage.height/2);
          //textAlign(CENTER);
          text(nf(ratings[i], 0, 2) + " (" + frequency[i] + ")", x, y-8);
          textAlign(LEFT);
        }
      }

  }









