int WIDTH = 1200;
int HEIGHT = 800;

int MINWORDLENGTH = 5;

int DEATHAT = 12;

String word = "";
int wordLength = 0;

char[] guessedWord;

boolean[] lettersGuessed = new boolean[26];

int leftPixelPoint = 0;

int deathCounter = 0;

PImage[] deathImages = new PImage[12];

void loadDeathImages() {
    for (int i = 0; i < 12; i++) {
        deathImages[i] = loadImage("imgs/" + Integer.toString(i + 1) + ".png");
    }
}

String chooseWord() {
    JSONObject file = loadJSONObject("words.json");
    JSONArray wordList = file.getJSONArray("data");
    int length = wordList.size();
    String word = "";
    while(word.length() <= MINWORDLENGTH) {
        word = wordList.getString(int(random(0, length)));
        // word = wordList.getString(213);
    }
    return word;
}

void startGame() {
    word = chooseWord();
    wordLength = word.length();
    lettersGuessed = new boolean[26];
    guessedWord = new char[wordLength];
    deathCounter = 0;
    for (int i = 0; i < wordLength; i++) {
        if ((word.charAt(i) == '-') || (word.charAt(i) == ' ')) {
            guessedWord[i] = word.charAt(i);
        }
        else {
            guessedWord[i] = ' ';
        }
    }
    println(word);
}

void guess(char c) {
    if (lettersGuessed[int(c) - 97]) {
        return;
    }
    print("YOU GUESSED: ");
    println(c);
    lettersGuessed[int(c) - 97] = true;
    if (word.indexOf(c) > - 1) {
        for (int i = 0; i < wordLength; i++) {
            if (word.charAt(i) == c) {
                guessedWord[i] = c;
            }
        }
    }
    else {
        deathCounter++;
        if (deathCounter >= DEATHAT) {
            deathCounter = DEATHAT;
        }
    }
}

void setup() {
    size(1200, 800);
    PFont epicFont;
    epicFont = createFont("Comic Sans MS", 32);
    textFont(epicFont);
    loadDeathImages();
    noLoop();
    loop();
    startGame();
}


void draw() {
    background(18);
    textSize(100);
    textAlign(CENTER);
    int pixelWordLength = wordLength * 80;
    int leftPixelPoint = (WIDTH - pixelWordLength) / 2;
    for (int i = 0; i < wordLength; i++) {
        text(guessedWord[i], leftPixelPoint + 30, 200);
        if (word.charAt(i) != ' ' && word.charAt(i) != '-') {
            line(leftPixelPoint, 210, leftPixelPoint + 60, 210);
        }
        leftPixelPoint += 80;
    }
    stroke(255, 255, 255);

    for (int i = 0; i < deathCounter; i++) {
        pushMatrix();
        image(deathImages[i], 350, 250);
        popMatrix();
    }

    int pixelCharLength = 26 * 20;
    int xPos = (WIDTH - pixelCharLength) / 2;
    textSize(20);
    for (int i = 0; i < 26; i++) {
        if (lettersGuessed[i]) {
            text(char(97 + i), xPos, 700);
        }
        line(xPos - 8, 710, xPos + 8, 710);
        xPos += 20;
    }
}

void keyPressed() {
    int k = int(key);
    if (key == '1') {
        startGame();
    }
    else if (k >= 97 && k <= 122) {
        guess(key);
    }
    else if (k >= 65 && k <= 91) {
        guess(char(int(key) + 32));
    }
    loop();
}
