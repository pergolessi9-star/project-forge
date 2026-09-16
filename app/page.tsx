const stages = [
  ["INTAKE", "Idea capture"],
  ["PROBLEM", "Problem evidence"],
  ["MARKET", "Market discovery"],
  ["TECHNOLOGY", "Feasibility"],
  ["REGULATION", "Compliance"],
  ["EVIDENCE", "Verification"]
];

const projects = [
  { code: "PF-0001", name: "Project Forge Demonstrator", stage: "EVIDENCE", status: "DISCOVERY", evidence: 1 },
  { code: "PF-0002", name: "New Project Candidate", stage: "INTAKE", status: "IDEA", evidence: 0 }
];

export default function Dashboard() {
  return (
    <div className="shell">
      <header className="topbar">
        <div className="brand">PROJECT FORGE</div>
        <div className="version">DISCOVERY ENGINE · v0.1.0</div>
      </header>

      <main className="main">
        <section className="hero">
          <div>
            <div className="eyebrow">Evidence before engineering</div>
            <h1>Discovery Command Center</h1>
            <div className="subtitle">
              Transform ideas into evidence-backed project concepts, validate them,
              and only then generate the engineering package.
            </div>
          </div>
          <button className="button">+ New Project</button>
        </section>

        <section className="grid">
          <div className="card"><div className="label">Projects</div><div className="metric">2</div></div>
          <div className="card"><div className="label">In Discovery</div><div className="metric">1</div></div>
          <div className="card"><div className="label">Evidence Items</div><div className="metric">1</div></div>
          <div className="card"><div className="label">Human Reviews</div><div className="metric">0</div></div>
        </section>

        <section className="section">
          <h2>Discovery Pipeline</h2>
          <div className="pipeline">
            {stages.map(([name, label], i) => (
              <div className={"stage " + (i === 5 ? "active" : "")} key={name}>
                <strong>{name}</strong><small>{label}</small>
              </div>
            ))}
          </div>
        </section>

        <section className="section">
          <h2>Projects</h2>
          <table className="table">
            <thead><tr><th>Code</th><th>Project</th><th>Stage</th><th>Status</th><th>Evidence</th></tr></thead>
            <tbody>
              {projects.map(p => (
                <tr key={p.code}>
                  <td>{p.code}</td>
                  <td><strong>{p.name}</strong></td>
                  <td><span className="badge">{p.stage}</span></td>
                  <td>{p.status}</td>
                  <td>{p.evidence}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </section>

        <section className="section">
          <div className="card">
            <div className="eyebrow">Governance boundary</div>
            <h2>AI output is not automatically verified evidence.</h2>
            <p className="subtitle">
              Every material claim must be traceable to a source and, where required,
              pass human verification before it becomes accepted project knowledge.
            </p>
          </div>
        </section>
      </main>
    </div>
  );
}
