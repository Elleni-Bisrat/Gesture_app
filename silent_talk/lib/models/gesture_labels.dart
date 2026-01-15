class GestureLabels {
  static final Map<int, String> labels = {
    0: "Hello",
    1: "Thank you",
    2: "Yes",
    3: "No",
    4: "Please",
    5: "Sorry",
    6: "Good morning",
    7: "Good night",
    8: "Help",
    9: "Water",
    10: "Food",
    11: "Bathroom",
    12: "How are you?",
    13: "I love you",
    14: "Stop",
    15: "Go",
    16: "Wait",
    17: "Danger",
    18: "Medicine",
    19: "Doctor",
    20: "Hospital",
    21: "Pain",
    22: "Happy",
    23: "Sad",
    24: "Angry",
    25: "Tired",
    26: "Hungry",
    27: "Thirsty",
    28: "Hot",
    29: "Cold",
    30: "Goodbye",
  };

  static String getLabel(int index) {
    return labels[index] ?? "Unknown Gesture";
  }

  static int getLabelIndex(String label) {
    return labels.entries.firstWhere(
      (entry) => entry.value == label,
      orElse: () => const MapEntry(-1, "Unknown")
    ).key;
  }
}