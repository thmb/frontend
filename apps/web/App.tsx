import { MantineProvider, Stack, Text, Title } from "@mantine/core";
import { PrimaryButton, StatusCard } from "@thmb/components";
import { theme } from "./theme";

const App = () => (
  <MantineProvider theme={theme}>
    <Stack p="xl" gap="md">
      <Title order={1}>THMB Frontend Blueprint</Title>
      <Text c="dimmed">
        Shared components are rendered from packages/components in both web and mobile.
      </Text>
      <StatusCard title="Shared Component" description="This card uses react-native primitives and runs on web." />
      <PrimaryButton label="Example action" onPress={() => {}} testID="shared-button" />
    </Stack>
  </MantineProvider>
);

export default App;
