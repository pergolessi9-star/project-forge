export interface AIProviderConfig {
  name: string;
  model: string;
  apiKey?: string;
}

export interface AIProviderAdapter {
  run(input: {
    task: string;
    payload: unknown;
    config: AIProviderConfig;
  }): Promise<unknown>;
}
