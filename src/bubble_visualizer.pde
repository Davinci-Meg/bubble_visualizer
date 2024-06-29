import processing.core.*;
import processing.data.*;
import processing.sound.*;

SoundFile soundFile;
Amplitude amp;
float[] ballXs;
float[] ballYs;
float[] ballRGB;
float[] initialSizes; // Store initial sizes separately for dynamic resizing
float volumeMultiplier = 1.0;
float volumeThreshold = 0.01; // Set the threshold for sound level

void setup() {
  size(1200, 1200); // Set the size of the canvas
  loadCSV("assets\bubble_data.csv"); // Load the CSV file containing bubble data

  soundFile = new SoundFile(this, "assets\Debussy.mp3"); // Load the audio file
  amp = new Amplitude(this); // Initialize the amplitude analyzer
  amp.input(soundFile); // Connect the amplitude analyzer to the audio input
  soundFile.play(); // Play the audio file
}

void draw() {
  background(255, 255, 255); // Set the background color to white

  // Update the volume multiplier based on the audio level
  float volume = amp.analyze();
  
  if (volume > volumeThreshold) {
    volumeMultiplier = map(volume, 0, 0.5, 1, 5); // Map the volume to a suitable range for resizing
  } else {
    volumeMultiplier = 1; // Reset multiplier to 1 when volume is below the threshold
  }

  // Draw the bubbles
  for (int i = 0; i < ballXs.length; i++) {
    // Set the color based on the RGB values
    if (i % 3 == 0) {
      fill(0, 0, ballRGB[i]);
    } else if (i % 3 == 1){
      fill(0, ballRGB[i], 0);
    } else if (i % 3 == 2){
      fill(ballRGB[i], ballRGB[i], 0);
    }
    float adjustedSize = initialSizes[i] * volumeMultiplier; // Adjust the size based on the volume
    ellipse(ballXs[i], ballYs[i], adjustedSize, adjustedSize); // Draw the ellipse
  }
}

void loadCSV(String fileName) {
  Table table = loadTable(fileName, "header"); // Load the CSV file with a header
  int rowCount = table.getRowCount(); // Get the number of rows in the table

  ballXs = new float[rowCount];
  ballYs = new float[rowCount];
  ballRGB = new float[rowCount];
  initialSizes = new float[rowCount];

  // Populate the arrays with data from the CSV file
  for (int i = 0; i < rowCount; i++) {
    TableRow row = table.getRow(i);
    ballXs[i] = row.getFloat("ballXs");
    ballYs[i] = row.getFloat("ballYs");
    ballRGB[i] = row.getFloat("ballRGB");
    initialSizes[i] = row.getFloat("ballSizes"); // Store initial sizes
  }
}
