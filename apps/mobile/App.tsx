import { StatusBar } from "expo-status-bar";
import { SafeAreaView, StyleSheet, Text, View } from "react-native";
import { PrimaryButton, StatusCard } from "@thmb/components";

export default function App() {
  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.content}>
        <Text style={styles.title}>THMB Mobile Blueprint</Text>
        <StatusCard
          title="Shared Component"
          description="This same component is consumed by web and mobile apps."
        />
        <PrimaryButton label="Example action" onPress={() => {}} testID="mobile-shared-button" />
      </View>
      <StatusBar style="auto" />
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#FFFFFF"
  },
  content: {
    flex: 1,
    paddingHorizontal: 20,
    paddingTop: 24,
    gap: 16
  },
  title: {
    fontSize: 28,
    fontWeight: "700",
    color: "#111827"
  }
});
