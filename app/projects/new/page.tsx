"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";

export default function NewProjectPage() {
  const router = useRouter();
  const [form, setForm] = useState({ code: "", name: "", description: "", owner: "" });
  const [error, setError] = useState("");
  const [busy, setBusy] = useState(false);
  const update = (key: string, value: string) => setForm((f) => ({ ...f, [key]: value }));
  async function submit(e: React.FormEvent) {
    e.preventDefault(); setBusy(true); setError("");
    try {
      const r = await fetch("/api/projects", { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify(form) });
      const data = await r.json();
      if (!r.ok) throw new Error(data.error || "Could not create project");
      router.push(`/projects/${data.id}`);
    } catch (err) { setError(err instanceof Error ? err.message : "Could not create project"); setBusy(false); }
  }
  return <div className="shell"><header className="topbar"><div className="brand">PROJECT FORGE</div><div className="version">NEW PROJECT · INTAKE</div></header><main className="main narrow"><section className="hero"><div><div className="eyebrow">Evidence before engineering</div><h1>New Project</h1><p className="subtitle">Capture the hypothesis. PROJECT FORGE will initialize the discovery gates and keep research claims separate from verified evidence.</p></div></section><form className="card form" onSubmit={submit}><label>Project code<input required maxLength={50} value={form.code} onChange={e=>update("code",e.target.value)} placeholder="PF-0002" /></label><label>Project name<input required maxLength={255} value={form.name} onChange={e=>update("name",e.target.value)} placeholder="Project working title" /></label><label>Description<textarea rows={5} value={form.description} onChange={e=>update("description",e.target.value)} placeholder="What is the project hypothesis?" /></label><label>Owner<input maxLength={255} value={form.owner} onChange={e=>update("owner",e.target.value)} placeholder="Person or team" /></label>{error&&<div className="error">{error}</div>}<div className="actions"><a className="button secondary" href="/">Cancel</a><button className="button" disabled={busy}>{busy?"Creating…":"Create project"}</button></div></form></main></div>;
}
