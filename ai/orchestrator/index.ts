export interface AIProvider {
  readonly name: string;
  run(input: { task: string; payload: unknown }): Promise<unknown>;
}

export class AIOrchestrator {
  constructor(private readonly providers: AIProvider[]) {}

  async run(task: string, payload: unknown) {
    const provider = this.providers[0];
    if (!provider) throw new Error("No AI provider configured.");
    return provider.run({ task, payload });
  }
}
