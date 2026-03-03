export type SessionState = {
  token: string | null;
};

export function createSessionState(): SessionState {
  return { token: null };
}
