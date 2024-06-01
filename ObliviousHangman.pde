int WIDTH = 1200;
int HEIGHT = 800;

int MINWORDLENGTH = 5;

String word = "";
int wordLength = 0;

char[] guessedWord;

boolean[] lettersGuessed = new boolean[26];

int leftPixelPoint = 0;

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

void startGame() {
    word = chooseWord();
    wordLength = word.length();
    lettersGuessed = new boolean[26];
    guessedWord = new char[wordLength];
    for (int i = 0; i < wordLength; i++) {
        guessedWord[i] = ' ';
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
}

void setup() {
    size(1200, 800);
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
        line(leftPixelPoint, 210, leftPixelPoint + 60, 210);
        leftPixelPoint += 80;
    }
    // text(new String(guessedWord), 400, 200);
    stroke(255, 255, 255);
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
}
