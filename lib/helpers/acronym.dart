String makeAcronym(String input) {
  String acronym = "";
  List<String> allWords = input.split(" ");

  switch (allWords.length) {
    // If there are 2 words add the first letter of each word
    case 2:
      acronym = allWords[0][0] + allWords[1][0];
      break;

    default:
      // If there is 1 word of 1 length just make it acronym
      if (allWords[0].length == 1) {
        acronym = allWords[0][0];
      }
      // else just add first and last letter
      else {
        acronym = allWords[0][0] + input[input.length - 1];
      }
  }

  return acronym;
}
