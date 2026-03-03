import { Pressable, StyleSheet, Text } from "react-native";

type PrimaryButtonProps = {
  label: string;
  onPress: () => void;
  testID?: string;
};

export function PrimaryButton({ label, onPress, testID }: PrimaryButtonProps) {
  return (
    <Pressable style={styles.button} onPress={onPress} testID={testID}>
      <Text style={styles.label}>{label}</Text>
    </Pressable>
  );
}

const styles = StyleSheet.create({
  button: {
    backgroundColor: "#00CC62",
    paddingVertical: 12,
    paddingHorizontal: 16,
    borderRadius: 10,
    alignItems: "center"
  },
  label: {
    color: "#FFFFFF",
    fontSize: 15,
    fontWeight: "600"
  }
});
