int MINWORDLENGTH = 5;

String word;

String chooseWord() {
    JSONObject file = loadJSONObject("words.json");
    JSONArray wordList = file.getJSONArray("data");
    int length = wordList.size();
    String word = "";
    while (word.length() <= MINWORDLENGTH) {
        word = wordList.getString(int(random(0, length)));
    }
    return word;
}

void setup() {
    // size(800, 800);
    word = chooseWord();
    println(word);
}

void draw() {
    background(18);
}

void keyPressed() {

}
