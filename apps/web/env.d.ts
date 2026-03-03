/// <reference types="@rsbuild/core/types" />

interface ImportMetaEnv {
  readonly API?: string;
}

interface ImportMeta {
  readonly env: ImportMetaEnv;
}
