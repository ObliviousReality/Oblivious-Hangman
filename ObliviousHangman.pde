int WIDTH = 1200;
int HEIGHT = 800;

int MINWORDLENGTH = 5;

int DEATHAT = 11;

String word = "";
int wordLength = 0;

char[] guessedWord;

boolean[] lettersGuessed = new boolean[26];

int numLettersGuessed = 0;

int leftPixelPoint = 0;

int deathCounter = 0;

PImage[] deathImages = new PImage[12];

boolean atEndGame = false;

void loadDeathImages() {
    for (int i = 0; i < 12; i++) {
        deathImages[i] = loadImage("./imgs/" + (i + 1) + ".png");
    }
}

String chooseWord() {
    JSONObject file = loadJSONObject("words.json");
    JSONArray wordList = file.getJSONArray("data");
    int length = wordList.size();
    String word = "";
    while(word.length() <= MINWORDLENGTH) {
        word = wordList.getString(int(random(0, length)));
    }
    return word;
}

void revealWord() {
    for (int i = 0; i < wordLength; i++) {
        guessedWord[i] = word.charAt(i);
    }
}

void startGame() {
    word = chooseWord();
    wordLength = word.length();
    lettersGuessed = new boolean[26];
    guessedWord = new char[wordLength];
    numLettersGuessed = 0;
    deathCounter = 0;
    for (int i = 0; i < wordLength; i++) {
        if ((word.charAt(i) == '-') || (word.charAt(i) == ' ')) {
            guessedWord[i] = word.charAt(i);
            numLettersGuessed++;
        }
        else {
            guessedWord[i] = ' ';
        }
    }
}

void endGame() {
    atEndGame = true;
    revealWord();
    loop();
}

void guess(char c) {
    if (lettersGuessed[int(c) - 97]) {
        return;
    }
    lettersGuessed[int(c) - 97] = true;
    if (word.indexOf(c) > - 1) {
        for (int i = 0; i < wordLength; i++) {
            if (word.charAt(i) == c) {
                guessedWord[i] = c;
                numLettersGuessed++;
                if (numLettersGuessed == wordLength) {
                    endGame();
                }
            }
        }
    }
    else {
        deathCounter++;
        if (deathCounter >= DEATHAT) {
            deathCounter = 12;
            endGame();
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
        image(deathImages[i], 300, 250);
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

    if (atEndGame) {
        textSize(100);
        text("Word Was: ", 600, 100);
        textSize(200);
        String endText = "";
        if (deathCounter == 12) {
            fill(255,0,0);
            endText = "You      Died!";
        }
        else {
            fill(107, 22, 162);
            endText = "You       Won!";
        }
        text(endText, 600, 400);
        textSize(100);
        text("Press Any Key to Restart", 600, 650);
        fill(255);
    }
}

void keyPressed() {
    if (atEndGame) {
        atEndGame = false;
        startGame();
        return;
    }
    int k = int(key);
    if (key == '1') {
        startGame();
    }
    else if (k >= 97 && k <= 122) {
        guess(key);
    }
    else if (k >= 65 && k <= 90) {
        guess(char(int(key) + 32));
    }
    loop();
}
