import { AIProvider } from "./provider.interface";

export class OpenAICompatibleProvider implements AIProvider{
 readonly name="openai-compatible";
 constructor(private readonly apiKey:string,private readonly model:string,private readonly baseUrl:string="https://api.openai.com/v1"){}
 async run(input:{task:string;payload:unknown}){
  const response=await fetch(`${this.baseUrl.replace(/\/$/,"")}/chat/completions`,{method:"POST",headers:{"content-type":"application/json",authorization:`Bearer ${this.apiKey}`},body:JSON.stringify({model:this.model,temperature:0.1,response_format:{type:"json_object"},messages:[{role:"system",content:input.task},{role:"user",content:JSON.stringify(input.payload)}]})});
  if(!response.ok) throw new Error(`AI provider HTTP ${response.status}`);
  const data=await response.json();
  const content=data?.choices?.[0]?.message?.content;
  if(!content) throw new Error("AI provider returned no content");
  return content;
 }
}
