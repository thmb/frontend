import React from "react";
import { MantineProvider } from "@mantine/core";
import { theme } from "./theme";

const App: React.FC = () => (
  <MantineProvider theme={theme}>
    <div>Raio Energia - Frontend</div>
  </MantineProvider>
);

export default App;
