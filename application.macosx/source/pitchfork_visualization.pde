
/*
Dataset downloaded from "Pitchfork // A Statistical Look at Their Ratings"
http://www.parttimemusic.com/2010/02/25/pitchfork-a-statistical-look-at-their-ratings/
 */


import processing.core.*;

//import library to import data from Excel file
import de.bezier.data.*;

//import charts
import org.gicentre.utils.stat.*;

  XlsReader reader;

  float plotX1, plotY1;
  float plotX2, plotY2;
  float labelX, labelY;
  String title;

  int rowCount;

  int column = 1;

  float ratingsMin = 0;
  float ratingsMax = 10;
  float freqMin = 0;
  float freqMax = 52;

  float[] ratings;
  float[] frequency;


  double ratingInterval = .2;
  float frequencyInterval = 2;


  public void setup() {
        reader = new XlsReader( this, "Pitchfork_List.xls" );
            reader.firstRow();


    size( 600, 400 );
    textFont(createFont("Helvetica",11),11);
    // Corners of the plotted time series
    plotX1 = 40; 
    plotX2 = width - 40;
    labelX = 50;
    plotY1 = 60;
    plotY2 = height - 70;
    labelY = height - 25;
    smooth();  

    PImage myImage = loadImage("pitchfork-logo.png");
    
    rowCount = reader.getLastRowNum()-2; 
    ratings = new float[rowCount];
    frequency = new float[rowCount];
    reader.firstRow();
    reader.firstCell();
    title = reader.getString();
    reader.nextRow();
    for( int i = 0; reader.hasMoreRows(); i++){
      reader.nextRow();
      ratings[i] = reader.getFloat(); //rating
      reader.nextCell();
      frequency[i] = reader.getFloat(); //frequency 
    }
  }


  void draw() {
    background(0);
    fill(255);
    rectMode(CORNERS);
    noStroke();
    rect(plotX1, plotY1, plotX2, plotY2);
    reader.firstCell();

    drawTitle();
    drawAxisLabels();
    drawRatingsLabels();
    drawFrequencyLabels();

    stroke(256);
    noFill();
    strokeWeight(2);
    drawDataLine(column);  
    drawDataHighlight(column);
  }




  
  void drawRatingsLabels() {
    fill(0);
    textSize(10);
    textAlign(CENTER);

    // Use thin, gray lines to draw the grid
    stroke(224);
    strokeWeight(1);

    for (int row = 0; row < rowCount; row++) {
      if (ratings[row] % ratingInterval == 0) {
        float x = map(ratings[row], ratingsMin, ratingsMax, plotX1, plotX2);
        text(ratings[row], x, plotY2 + textAscent() + 10);
        line(x, plotY1, x, plotY2);
      }
    }    
  }

  void drawAxisLabels() {
    fill(0);
    textSize(13);
    textLeading(15);

    textAlign(CENTER, CENTER);
    text("Total occurances of rating in 2010", labelX, (plotY1+plotY2)/2);
    textAlign(CENTER);
    text("Album Rating (out of 10.0)", (plotX1+plotX2)/2, labelY);

  }

  void drawTitle() {
    fill(0);
    textSize(20);
    textAlign(LEFT);
    text(title, plotX1, plotY1 - 10);
  }
  void drawFrequencyLabels() {
    fill(0);
    textSize(10);
    textAlign(RIGHT);

    stroke(128);
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
        text(floor(v), plotX1 - 10, y + textOffset);
        line(plotX1 - 4, y, plotX1, y);     // Draw major tick
      } 
    }
  }
  void drawDataPoints(int cell) {
    reader.firstCell();
    for (int row = 0; row < rowCount; row++) {
      //if (isValid(row+2, cell)) {
        float value = reader.getFloat(row+2, cell);
        float x = map(ratings[row], ratingsMin, ratingsMax, plotX1, plotX2);
        float y = map(value, freqMin, freqMax, plotY2, plotY1);
        point(x, y);
      //}
    }
  }

  void drawDataLine(int col) {  
    beginShape();

    for (int row = 0; row < rowCount; row++) {
    //  if (isValid(row+2, cell)) {

        float value = reader.getFloat((row+2), col);
        println("row: "+ (row+2) + " cell: " + col);
        float x = map(ratings[row], ratingsMin, ratingsMax, plotX1, plotX2);
        float y = map(value, freqMin, freqMax, plotY2, plotY1);      
        vertex(x, y);
      //}
    }
    endShape();
  }


  void drawDataHighlight(int cell) {
    reader.firstCell();

    for (int row = 0; row < rowCount; row++) {
      //if (isValid(row+2, cell)) {
        float value = reader.getFloat(row+2, cell);
        float x = map(ratings[row], ratingsMin, ratingsMax, plotX1, plotX2);
        float y = map(value, freqMin, freqMax, plotY2, plotY1);      
        if (dist(mouseX, mouseY, x, y) < 3) {
          strokeWeight(10);
          point(x, y);
          fill(0);
          textSize(10);
          textAlign(CENTER);
          text(nf(value, 0, 2) + " (" + ratings[row] + ")", x, y-8);
          textAlign(LEFT);
        }
      //}
    }
  }

  boolean isValid(int row, int cell){
    reader.firstCell();
    if (row < 0) return false;
    if (row >= rowCount+2) return false;
    if (cell < 0) return false;
    return !Float.isNaN(reader.getFloat(row, cell));

  }





