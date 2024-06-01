int MINWORDLENGTH = 5;

String word = "";
int wordLength = 0;

String guessedWord = "";

boolean[] lettersGuessed = new boolean[26];

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
    guessedWord = "";
    println(word);
}

void guess(char c) {
    print("YOU GUESSED: ");
    println(c);
    lettersGuessed[int(c) - 97] = true;
}

void setup() {
    size(800, 800);
    startGame();
}


void draw() {
    background(18);
    textSize(20);
    text(word, 100, 100);
    int xPos = 100;
    for (int i = 0; i < 26; i++) {
        if (lettersGuessed[i]) {
            text(char(97 + i), xPos, 200);
        }
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
