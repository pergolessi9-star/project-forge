import { getDiscovery } from "@/domain/discovery/service";
import DiscoveryCommandCenter from "./DiscoveryCommandCenter";

export const dynamic="force-dynamic";

export default async function ProjectDiscovery({params}:{params:{id:string}}){
 const d=await getDiscovery(params.id);
 if(!d.project)return <main className="main"><h1>Project not found</h1></main>;
 return <div className="shell"><header className="topbar"><div className="brand">PROJECT FORGE</div><div className="version">DISCOVERY COMMAND CENTER</div></header><main className="main"><DiscoveryCommandCenter projectId={params.id} initial={d}/></main></div>;
}
