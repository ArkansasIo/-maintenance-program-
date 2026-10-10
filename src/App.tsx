import { useState } from 'react';

const menus = [
  ['Dashboard', ['Overview', 'Alerts', 'Today']],
  ['Maintenance', ['Work Orders', 'Preventive Maintenance', 'Inspections', 'History']],
  ['Assets', ['Asset Register', 'Equipment', 'Meters', 'Documents']],
  ['Inventory', ['Parts', 'Stock', 'Reorder List', 'Purchase Orders']],
  ['People', ['Employees', 'Technicians', 'Teams', 'Vendors']],
  ['Locations', ['Sites', 'Buildings', 'Areas', 'Departments']],
  ['Documents', ['Manuals', 'Certificates', 'Photos', 'Warranties']],
  ['Reports', ['Maintenance', 'Costs', 'Downtime', 'PM Compliance']],
  ['Administration', ['Users', 'Roles', 'Permissions', 'Audit Log']]
];

export default function App() {
  const [selected, setSelected] = useState('Overview');

  return <div className="app">
    <header className="topbar">
      <div className="brand">WORKPLACE MAINTENANCE</div>
      <input className="global-search" placeholder="Search assets, work orders, people..." />
      <div className="user">Admin ▾</div>
    </header>
    <div className="shell">
      <aside className="sidebar">
        {menus.map(([menu, subs]) => <section key={menu}>
          <div className="menu-title">{menu}</div>
          {(subs as string[]).map(item => <button
            className={selected === item ? 'nav active' : 'nav'}
            onClick={() => setSelected(item)} key={item}>{item}</button>)}
        </section>)}
      </aside>
      <main className="content">
        <div className="page-head">
          <div><h1>{selected}</h1><p>Universal maintenance and work management.</p></div>
          <button className="primary">+ New Work Order</button>
        </div>
        <div className="metrics">
          <div className="metric"><span>Open Work Orders</span><strong>142</strong></div>
          <div className="metric"><span>Overdue</span><strong>17</strong></div>
          <div className="metric"><span>PM Due</span><strong>24</strong></div>
          <div className="metric"><span>Low Stock</span><strong>8</strong></div>
        </div>
        <div className="panel">
          <h2>Maintenance Activity</h2>
          <table><thead><tr><th>Work Order</th><th>Asset</th><th>Priority</th><th>Status</th><th>Due</th></tr></thead>
          <tbody>
            <tr><td>WO-1001</td><td>Walk-in Cooler</td><td><span className="badge danger">High</span></td><td>Open</td><td>2026-10-10</td></tr>
            <tr><td>WO-1002</td><td>HVAC Unit</td><td><span className="badge warn">Medium</span></td><td>Assigned</td><td>2026-10-12</td></tr>
            <tr><td>WO-1003</td><td>Loading Door</td><td><span className="badge">Low</span></td><td>Completed</td><td>2026-10-08</td></tr>
          </tbody></table>
        </div>
      </main>
    </div>
  </div>;
}