String makeAcronym(String input) {
  String acronym = "";
  List<String> allWords = input.split(" ");
  for (int i = 0; i < allWords.length; i++) {
    // add the first letter of each word
    acronym += allWords[i][0];
  }
  if (acronym.length < 2) {
    acronym += input[input.length - 1];
  } else {
    acronym = acronym[0] + input[input.length - 1];
  }
  return acronym;
}
