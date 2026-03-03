import { StyleSheet, Text, View } from "react-native";

type StatusCardProps = {
  title: string;
  description: string;
};

export function StatusCard({ title, description }: StatusCardProps) {
  return (
    <View style={styles.card}>
      <Text style={styles.title}>{title}</Text>
      <Text style={styles.description}>{description}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  card: {
    borderWidth: 1,
    borderColor: "#D1D5DB",
    borderRadius: 12,
    padding: 16,
    gap: 8,
    backgroundColor: "#FFFFFF"
  },
  title: {
    fontSize: 18,
    fontWeight: "700",
    color: "#111827"
  },
  description: {
    fontSize: 14,
    lineHeight: 20,
    color: "#4B5563"
  }
});
