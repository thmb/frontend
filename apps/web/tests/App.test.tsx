import { render, screen } from "@testing-library/react";
import App from "../App";

describe("App", () => {
  it("renders blueprint title", () => {
    render(<App />);
    expect(screen.getByText("THMB Frontend Blueprint")).toBeTruthy();
  });
});
