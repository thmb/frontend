import { render, screen } from "@testing-library/react-native";
import App from "../App";

describe("Mobile App", () => {
  it("renders mobile blueprint title", () => {
    render(<App />);
    expect(screen.getByText("THMB Mobile Blueprint")).toBeTruthy();
  });
});
