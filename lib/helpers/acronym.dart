String makeAcronym(String input) {
  String acronym = "";
  List<String> allWords = input.split(" ");

  if (allWords.length == 2) {
    // acronym += input[input.length - 1];
    // add the first letter of each word
    acronym = allWords[0][0] + allWords[1][0];
  } else {
    acronym = allWords[0][0] + input[input.length - 1];
  }
  return acronym;
}
