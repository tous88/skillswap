<!DOCTYPE html>

<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>SkillSwap — Hire Fast. Earn Faster.</title>
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:ital,wght@0,300;0,400;0,500;1,300&display=swap" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>
<script src="https://js.stripe.com/v3/"></script>
<style>
  :root {
    --ink: #0a0a0f;
    --paper: #f5f3ee;
    --cream: #ede9e0;
    --accent: #e8440a;
    --accent2: #2d6a4f;
    --gold: #c9a84c;
    --muted: #7a7671;
    --card: #ffffff;
    --border: #ddd9d0;
  }
  * { margin:0; padding:0; box-sizing:border-box; }
  body { font-family:'DM Sans',sans-serif; background:var(--paper); color:var(--ink); min-height:100vh; }

nav {
display:flex; align-items:center; justify-content:space-between;
padding:18px 40px; background:var(–ink);
position:sticky; top:0; z-index:100;
}
.logo { font-family:‘Syne’,sans-serif; font-weight:800; font-size:1.5rem; color:var(–paper); letter-spacing:-0.5px; }
.logo span { color:var(–accent); }
.nav-links { display:flex; gap:12px; align-items:center; }
.nav-btn { font-family:‘DM Sans’,sans-serif; font-size:0.85rem; font-weight:500; padding:9px 20px; border-radius:6px; cursor:pointer; border:none; transition:all 0.2s; }
.nav-ghost { background:transparent; color:var(–paper); border:1px solid rgba(255,255,255,0.2); }
.nav-ghost:hover { border-color:var(–accent); color:var(–accent); }
.nav-solid { background:var(–accent); color:#fff; }
.nav-solid:hover { background:#c93a08; }
.nav-user { font-family:‘Syne’,sans-serif; font-size:0.8rem; font-weight:700; color:rgba(255,255,255,0.6); }

.tabs { display:flex; background:var(–ink); padding:0 40px; border-top:1px solid rgba(255,255,255,0.08); }
.tab { font-family:‘Syne’,sans-serif; font-size:0.8rem; font-weight:600; color:rgba(255,255,255,0.45); padding:12px 20px; cursor:pointer; border-bottom:2px solid transparent; transition:all 0.2s; letter-spacing:0.5px; text-transform:uppercase; }
.tab.active { color:var(–paper); border-bottom-color:var(–accent); }
.tab:hover { color:var(–paper); }

.view { display:none; }
.view.active { display:block; }

.hero { padding:80px 40px 60px; max-width:1100px; margin:0 auto; display:grid; grid-template-columns:1fr 1fr; gap:60px; align-items:center; }
.hero-eyebrow { font-family:‘Syne’,sans-serif; font-size:0.75rem; font-weight:700; letter-spacing:2px; text-transform:uppercase; color:var(–accent); margin-bottom:16px; }
.hero h1 { font-family:‘Syne’,sans-serif; font-size:3.4rem; font-weight:800; line-height:1.05; letter-spacing:-1.5px; color:var(–ink); margin-bottom:20px; }
.hero h1 em { font-style:normal; color:var(–accent); }
.hero p { font-size:1.05rem; color:var(–muted); line-height:1.7; margin-bottom:32px; font-weight:300; }
.hero-ctas { display:flex; gap:12px; flex-wrap:wrap; }
.btn-primary { background:var(–accent); color:#fff; padding:14px 28px; border-radius:8px; border:none; font-family:‘Syne’,sans-serif; font-weight:700; font-size:0.9rem; cursor:pointer; transition:all 0.2s; }
.btn-primary:hover { background:#c93a08; transform:translateY(-1px); }
.btn-secondary { background:transparent; color:var(–ink); padding:14px 28px; border-radius:8px; border:2px solid var(–border); font-family:‘Syne’,sans-serif; font-weight:700; font-size:0.9rem; cursor:pointer; transition:all 0.2s; }
.btn-secondary:hover { border-color:var(–ink); }

.stats-card { background:var(–ink); border-radius:16px; padding:36px; display:grid; grid-template-columns:1fr 1fr; gap:24px; }
.stat-num { font-family:‘Syne’,sans-serif; font-size:2.2rem; font-weight:800; color:var(–paper); line-height:1; }
.stat-num span { color:var(–accent); }
.stat-label { font-size:0.8rem; color:rgba(255,255,255,0.4); margin-top:4px; letter-spacing:0.5px; text-transform:uppercase; }
.stat-divider { grid-column:1/-1; height:1px; background:rgba(255,255,255,0.08); }

.section { padding:60px 40px; max-width:1100px; margin:0 auto; }
.section-header { margin-bottom:36px; }
.section-eyebrow { font-family:‘Syne’,sans-serif; font-size:0.72rem; font-weight:700; letter-spacing:2px; text-transform:uppercase; color:var(–accent); margin-bottom:10px; }
.section h2 { font-family:‘Syne’,sans-serif; font-size:2rem; font-weight:800; letter-spacing:-0.5px; color:var(–ink); }

.jobs-grid { display:grid; grid-template-columns:repeat(auto-fill,minmax(320px,1fr)); gap:18px; }
.job-card { background:var(–card); border:1px solid var(–border); border-radius:12px; padding:24px; cursor:pointer; transition:all 0.2s; position:relative; overflow:hidden; }
.job-card:hover { transform:translateY(-2px); box-shadow:0 8px 30px rgba(0,0,0,0.08); border-color:var(–accent); }
.job-card::before { content:’’; position:absolute; top:0; left:0; right:0; height:3px; background:var(–accent); transform:scaleX(0); transform-origin:left; transition:transform 0.2s; }
.job-card:hover::before { transform:scaleX(1); }
.job-top { display:flex; justify-content:space-between; align-items:flex-start; margin-bottom:12px; }
.job-category { font-family:‘Syne’,sans-serif; font-size:0.68rem; font-weight:700; text-transform:uppercase; letter-spacing:1px; padding:4px 10px; border-radius:20px; background:var(–cream); color:var(–muted); }
.job-budget { font-family:‘Syne’,sans-serif; font-size:1rem; font-weight:800; color:var(–accent2); }
.job-title { font-family:‘Syne’,sans-serif; font-size:1.05rem; font-weight:700; color:var(–ink); margin-bottom:8px; line-height:1.3; }
.job-desc { font-size:0.85rem; color:var(–muted); line-height:1.6; margin-bottom:16px; }
.job-footer { display:flex; justify-content:space-between; align-items:center; }
.job-meta { font-size:0.78rem; color:var(–muted); }
.job-meta strong { color:var(–ink); }
.bid-btn { background:var(–ink); color:var(–paper); padding:8px 16px; border-radius:6px; border:none; font-family:‘Syne’,sans-serif; font-weight:700; font-size:0.78rem; cursor:pointer; transition:all 0.2s; }
.bid-btn:hover { background:var(–accent); }
.urgent-tag { font-size:0.68rem; font-weight:700; text-transform:uppercase; letter-spacing:1px; color:var(–accent); padding:3px 8px; background:rgba(232,68,10,0.1); border-radius:4px; }

.freelancers-grid { display:grid; grid-template-columns:repeat(auto-fill,minmax(260px,1fr)); gap:18px; }
.freelancer-card { background:var(–card); border:1px solid var(–border); border-radius:12px; padding:24px; text-align:center; cursor:pointer; transition:all 0.2s; }
.freelancer-card:hover { transform:translateY(-2px); box-shadow:0 8px 30px rgba(0,0,0,0.08); }
.avatar { width:64px; height:64px; border-radius:50%; margin:0 auto 12px; display:flex; align-items:center; justify-content:center; font-family:‘Syne’,sans-serif; font-weight:800; font-size:1.3rem; color:#fff; }
.freelancer-name { font-family:‘Syne’,sans-serif; font-weight:700; font-size:1rem; margin-bottom:4px; }
.freelancer-title { font-size:0.82rem; color:var(–muted); margin-bottom:12px; }
.freelancer-tags { display:flex; gap:6px; flex-wrap:wrap; justify-content:center; margin-bottom:14px; }
.tag { font-size:0.72rem; padding:3px 10px; border-radius:20px; background:var(–cream); color:var(–ink); font-weight:500; }
.freelancer-rate { font-family:‘Syne’,sans-serif; font-weight:800; font-size:1rem; color:var(–accent2); margin-bottom:14px; }
.hire-btn { width:100%; background:var(–ink); color:var(–paper); padding:10px; border-radius:8px; border:none; font-family:‘Syne’,sans-serif; font-weight:700; font-size:0.82rem; cursor:pointer; transition:all 0.2s; }
.hire-btn:hover { background:var(–accent); }

.post-form { max-width:640px; margin:0 auto; background:var(–card); border:1px solid var(–border); border-radius:16px; padding:40px; }
.form-row { margin-bottom:22px; }
.form-row label { display:block; font-family:‘Syne’,sans-serif; font-weight:700; font-size:0.82rem; letter-spacing:0.5px; text-transform:uppercase; color:var(–ink); margin-bottom:8px; }
.form-row input, .form-row textarea, .form-row select { width:100%; padding:12px 16px; border:1.5px solid var(–border); border-radius:8px; font-family:‘DM Sans’,sans-serif; font-size:0.95rem; color:var(–ink); background:var(–paper); transition:border-color 0.2s; outline:none; }
.form-row input:focus, .form-row textarea:focus, .form-row select:focus { border-color:var(–accent); }
.form-row textarea { min-height:110px; resize:vertical; }
.form-grid { display:grid; grid-template-columns:1fr 1fr; gap:16px; }
.submit-btn { width:100%; padding:16px; background:var(–accent); color:#fff; border:none; border-radius:8px; font-family:‘Syne’,sans-serif; font-weight:800; font-size:1rem; cursor:pointer; transition:all 0.2s; }
.submit-btn:hover { background:#c93a08; transform:translateY(-1px); }
.submit-btn:disabled { background:var(–muted); cursor:not-allowed; transform:none; }

.how-grid { display:grid; grid-template-columns:repeat(3,1fr); gap:24px; }
.how-card { background:var(–card); border:1px solid var(–border); border-radius:12px; padding:28px; }
.how-num { font-family:‘Syne’,sans-serif; font-size:2.5rem; font-weight:800; color:var(–accent); opacity:0.3; line-height:1; margin-bottom:12px; }
.how-card h3 { font-family:‘Syne’,sans-serif; font-weight:700; font-size:1rem; margin-bottom:8px; }
.how-card p { font-size:0.85rem; color:var(–muted); line-height:1.6; }

.revenue-banner { background:var(–ink); color:var(–paper); padding:48px 40px; text-align:center; }
.revenue-banner h2 { font-family:‘Syne’,sans-serif; font-weight:800; font-size:1.8rem; margin-bottom:8px; letter-spacing:-0.5px; }
.revenue-banner h2 span { color:var(–accent); }
.revenue-banner p { color:rgba(255,255,255,0.5); font-size:0.9rem; margin-bottom:28px; }
.rev-cards { display:flex; gap:16px; justify-content:center; flex-wrap:wrap; }
.rev-card { background:rgba(255,255,255,0.05); border:1px solid rgba(255,255,255,0.1); border-radius:12px; padding:24px 32px; min-width:200px; }
.rev-card-num { font-family:‘Syne’,sans-serif; font-weight:800; font-size:1.8rem; color:var(–accent); }
.rev-card-label { font-size:0.8rem; color:rgba(255,255,255,0.4); margin-top:4px; text-transform:uppercase; letter-spacing:1px; }

.modal-overlay { display:none; position:fixed; inset:0; background:rgba(0,0,0,0.55); z-index:200; align-items:center; justify-content:center; padding:20px; }
.modal-overlay.open { display:flex; }
.modal { background:var(–card); border-radius:16px; padding:36px; max-width:480px; width:100%; position:relative; max-height:90vh; overflow-y:auto; }
.modal-close { position:absolute; top:16px; right:16px; background:none; border:none; font-size:1.4rem; cursor:pointer; color:var(–muted); line-height:1; }
.modal h3 { font-family:‘Syne’,sans-serif; font-weight:800; font-size:1.3rem; margin-bottom:6px; }
.modal-sub { font-size:0.85rem; color:var(–muted); margin-bottom:24px; }
.modal-budget { font-family:‘Syne’,sans-serif; font-weight:800; font-size:1.6rem; color:var(–accent2); margin-bottom:20px; }

.toast { position:fixed; bottom:24px; right:24px; background:var(–ink); color:var(–paper); padding:14px 20px; border-radius:10px; font-family:‘Syne’,sans-serif; font-weight:700; font-size:0.85rem; z-index:999; transform:translateY(100px); opacity:0; transition:all 0.3s; max-width:320px; }
.toast.show { transform:translateY(0); opacity:1; }
.toast.success { border-left:4px solid var(–accent2); }
.toast.error { border-left:4px solid var(–accent); }

.auth-tabs { display:flex; gap:0; margin-bottom:24px; border:1.5px solid var(–border); border-radius:8px; overflow:hidden; }
.auth-tab { flex:1; padding:10px; text-align:center; cursor:pointer; font-family:‘Syne’,sans-serif; font-weight:700; font-size:0.82rem; background:transparent; border:none; color:var(–muted); transition:all 0.2s; }
.auth-tab.active { background:var(–ink); color:var(–paper); }

.profile-view { max-width:640px; margin:0 auto; background:var(–card); border:1px solid var(–border); border-radius:16px; padding:40px; }
.profile-header { display:flex; gap:20px; align-items:center; margin-bottom:32px; padding-bottom:32px; border-bottom:1px solid var(–border); }
.profile-avatar { width:80px; height:80px; border-radius:50%; background:var(–ink); display:flex; align-items:center; justify-content:center; font-family:‘Syne’,sans-serif; font-weight:800; font-size:1.8rem; color:var(–paper); flex-shrink:0; }
.profile-info h2 { font-family:‘Syne’,sans-serif; font-weight:800; font-size:1.4rem; margin-bottom:4px; }
.profile-info p { font-size:0.88rem; color:var(–muted); }
.role-badge { display:inline-block; padding:4px 12px; border-radius:20px; font-family:‘Syne’,sans-serif; font-weight:700; font-size:0.72rem; text-transform:uppercase; letter-spacing:1px; margin-top:6px; }
.role-client { background:rgba(45,106,79,0.12); color:var(–accent2); }
.role-freelancer { background:rgba(232,68,10,0.1); color:var(–accent); }

.loading { text-align:center; padding:60px 20px; color:var(–muted); font-family:‘Syne’,sans-serif; font-weight:700; font-size:0.9rem; letter-spacing:1px; text-transform:uppercase; }
.empty-state { text-align:center; padding:60px 20px; }
.empty-state h3 { font-family:‘Syne’,sans-serif; font-weight:800; font-size:1.2rem; margin-bottom:8px; }
.empty-state p { font-size:0.88rem; color:var(–muted); }

#stripe-card-element { padding:12px 16px; border:1.5px solid var(–border); border-radius:8px; background:var(–paper); }
.stripe-label { display:block; font-family:‘Syne’,sans-serif; font-weight:700; font-size:0.82rem; letter-spacing:0.5px; text-transform:uppercase; color:var(–ink); margin-bottom:8px; }
.fee-note { font-size:0.78rem; color:var(–muted); margin-top:8px; text-align:center; }

@media(max-width:768px){
nav { padding:16px 20px; }
.hero { grid-template-columns:1fr; gap:40px; padding:40px 20px; }
.hero h1 { font-size:2.4rem; }
.section { padding:40px 20px; }
.how-grid { grid-template-columns:1fr; }
.tabs { padding:0 20px; overflow-x:auto; }
.form-grid { grid-template-columns:1fr; }
.post-form, .profile-view { padding:24px 20px; }
.revenue-banner { padding:40px 20px; }
}
</style>

</head>
<body>

<nav>
  <div class="logo">Skill<span>Swap</span></div>
  <div class="nav-links" id="nav-links">
    <button class="nav-btn nav-ghost" onclick="openAuth('login')">Log In</button>
    <button class="nav-btn nav-solid" onclick="openAuth('signup')">Get Started Free</button>
  </div>
</nav>

<div class="tabs">
  <div class="tab active" onclick="switchTab('home')">Home</div>
  <div class="tab" onclick="switchTab('jobs')">Browse Jobs</div>
  <div class="tab" onclick="switchTab('talent')">Find Talent</div>
  <div class="tab" onclick="switchTab('post')">Post a Job</div>
  <div class="tab" id="tab-profile" style="display:none" onclick="switchTab('profile')">My Profile</div>
</div>

<!-- HOME -->

<div id="view-home" class="view active">
  <div class="hero">
    <div>
      <div class="hero-eyebrow">Freelance Marketplace</div>
      <h1>Hire Fast.<br>Earn <em>Faster.</em></h1>
      <p>SkillSwap connects consumers and businesses with top freelancers — in minutes. Post a job, get bids, pay securely, done.</p>
      <div class="hero-ctas">
        <button class="btn-primary" onclick="switchTab('post')">Post a Job — Free</button>
        <button class="btn-secondary" onclick="switchTab('talent')">Browse Talent</button>
      </div>
    </div>
    <div class="stats-card">
      <div class="stat"><div class="stat-num">2.4<span>K</span></div><div class="stat-label">Active Freelancers</div></div>
      <div class="stat"><div class="stat-num">98<span>%</span></div><div class="stat-label">Satisfaction Rate</div></div>
      <div class="stat-divider"></div>
      <div class="stat"><div class="stat-num">$1<span>M+</span></div><div class="stat-label">Paid to Freelancers</div></div>
      <div class="stat"><div class="stat-num">48<span>hr</span></div><div class="stat-label">Avg. Hire Time</div></div>
    </div>
  </div>
  <div class="section">
    <div class="section-header"><div class="section-eyebrow">How It Works</div><h2>Three steps to done.</h2></div>
    <div class="how-grid">
      <div class="how-card"><div class="how-num">01</div><h3>Post Your Job</h3><p>Describe what you need, set a budget, and publish in under 2 minutes.</p></div>
      <div class="how-card"><div class="how-num">02</div><h3>Receive Bids</h3><p>Vetted freelancers send proposals within hours. Compare rates and reviews.</p></div>
      <div class="how-card"><div class="how-num">03</div><h3>Pay Safely</h3><p>Funds held in escrow via Stripe. Release only when work is complete.</p></div>
    </div>
  </div>
</div>

<!-- JOBS -->

<div id="view-jobs" class="view">
  <div class="section">
    <div class="section-header"><div class="section-eyebrow">Open Opportunities</div><h2>Browse Live Jobs</h2></div>
    <div id="jobs-grid" class="jobs-grid"><div class="loading">Loading jobs...</div></div>
  </div>
</div>

<!-- TALENT -->

<div id="view-talent" class="view">
  <div class="section">
    <div class="section-header"><div class="section-eyebrow">Top Rated</div><h2>Find Talent</h2></div>
    <div id="freelancers-grid" class="freelancers-grid"><div class="loading">Loading talent...</div></div>
  </div>
</div>

<!-- POST A JOB -->

<div id="view-post" class="view">
  <div class="section">
    <div class="section-header" style="text-align:center"><div class="section-eyebrow">Get Started</div><h2>Post a Job</h2></div>
    <div class="post-form" id="post-form-wrap">
      <div class="form-row"><label>Job Title</label><input type="text" id="job-title" placeholder="e.g. Build me a landing page in 48 hours"></div>
      <div class="form-row"><label>Category</label>
        <select id="job-cat">
          <option value="">Select a category</option>
          <option>Web & App Development</option>
          <option>Design & Creative</option>
          <option>Marketing & SEO</option>
          <option>Writing & Content</option>
          <option>Video & Animation</option>
          <option>Business & Finance</option>
          <option>Admin & Virtual Assistant</option>
        </select>
      </div>
      <div class="form-row"><label>Job Description</label><textarea id="job-desc" placeholder="Describe what you need in detail..."></textarea></div>
      <div class="form-grid">
        <div class="form-row"><label>Budget ($)</label><input type="number" id="job-budget" placeholder="500"></div>
        <div class="form-row"><label>Deadline</label><input type="date" id="job-deadline"></div>
      </div>
      <div class="form-row" style="display:flex;align-items:center;gap:10px">
        <input type="checkbox" id="job-urgent" style="width:auto">
        <label for="job-urgent" style="text-transform:none;font-size:0.9rem;margin:0">Mark as urgent</label>
      </div>
      <button class="submit-btn" id="post-btn" onclick="postJob()">Post Job — It's Free →</button>
    </div>
  </div>
</div>

<!-- PROFILE -->

<div id="view-profile" class="view">
  <div class="section">
    <div id="profile-content"><div class="loading">Loading profile...</div></div>
  </div>
</div>

<!-- REVENUE BANNER -->

<div class="revenue-banner">
  <h2>Built to <span>Make Money</span></h2>
  <p>SkillSwap earns on every transaction — no fluff, no guesswork.</p>
  <div class="rev-cards">
    <div class="rev-card"><div class="rev-card-num">10%</div><div class="rev-card-label">Platform fee per job</div></div>
    <div class="rev-card"><div class="rev-card-num">$29/mo</div><div class="rev-card-label">Pro freelancer plan</div></div>
    <div class="rev-card"><div class="rev-card-num">$99/mo</div><div class="rev-card-label">Business listings</div></div>
  </div>
</div>

<!-- MODAL -->

<div class="modal-overlay" id="modal-overlay" onclick="handleOverlayClick(event)">
  <div class="modal">
    <button class="modal-close" onclick="closeModal()">×</button>
    <div id="modal-content"></div>
  </div>
</div>

<!-- TOAST -->

<div class="toast" id="toast"></div>

<script>
// ============================================================
// CONFIG — swap in your keys
// ============================================================
var SUPABASE_URL = 'https://cowwlpiatpyiadrllkzr.supabase.co';
var SUPABASE_ANON_KEY = 'YOUR_SUPABASE_ANON_KEY'; // paste from Supabase > Settings > API
var STRIPE_PUBLISHABLE_KEY = 'YOUR_STRIPE_PUBLISHABLE_KEY'; // paste from Stripe dashboard

var supabase = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
var stripe = Stripe(STRIPE_PUBLISHABLE_KEY);
var currentUser = null;
var currentProfile = null;

// ============================================================
// INIT
// ============================================================
supabase.auth.getSession().then(function(res) {
  if (res.data && res.data.session) {
    currentUser = res.data.session.user;
    loadProfile(currentUser.id);
    updateNav();
  }
});

supabase.auth.onAuthStateChange(function(event, session) {
  if (session) {
    currentUser = session.user;
    loadProfile(currentUser.id);
    updateNav();
  } else {
    currentUser = null;
    currentProfile = null;
    updateNav();
  }
});

// ============================================================
// NAV
// ============================================================
function updateNav() {
  var navLinks = document.getElementById('nav-links');
  var tabProfile = document.getElementById('tab-profile');
  if (currentUser) {
    var name = currentProfile ? currentProfile.full_name : currentUser.email;
    navLinks.innerHTML = '<span class="nav-user">Hi, ' + (name ? name.split(' ')[0] : 'there') + '</span>' +
      '<button class="nav-btn nav-ghost" onclick="signOut()">Sign Out</button>';
    tabProfile.style.display = 'block';
  } else {
    navLinks.innerHTML = '<button class="nav-btn nav-ghost" onclick="openAuth(\'login\')">Log In</button>' +
      '<button class="nav-btn nav-solid" onclick="openAuth(\'signup\')">Get Started Free</button>';
    tabProfile.style.display = 'none';
  }
}

// ============================================================
// TABS
// ============================================================
function switchTab(tab) {
  var views = ['home','jobs','talent','post','profile'];
  var tabs = document.querySelectorAll('.tab');
  for (var i = 0; i < views.length; i++) {
    document.getElementById('view-' + views[i]).classList.remove('active');
    if (tabs[i]) tabs[i].classList.remove('active');
  }
  document.getElementById('view-' + tab).classList.add('active');
  var idx = views.indexOf(tab);
  if (tabs[idx]) tabs[idx].classList.add('active');
  window.scrollTo(0, 0);

  if (tab === 'jobs') loadJobs();
  if (tab === 'talent') loadFreelancers();
  if (tab === 'profile') renderProfile();
}

// ============================================================
// AUTH
// ============================================================
function openAuth(mode) {
  renderAuthModal(mode);
  document.getElementById('modal-overlay').classList.add('open');
}

function renderAuthModal(mode) {
  var isLogin = mode === 'login';
  var html = '<div class="auth-tabs">' +
    '<button class="auth-tab ' + (isLogin ? 'active' : '') + '" onclick="renderAuthModal(\'login\')">Log In</button>' +
    '<button class="auth-tab ' + (!isLogin ? 'active' : '') + '" onclick="renderAuthModal(\'signup\')">Sign Up</button>' +
    '</div>';
  if (isLogin) {
    html += '<h3>Welcome Back</h3><p class="modal-sub">Log into your SkillSwap account.</p>';
    html += '<div class="form-row"><label>Email</label><input type="email" id="auth-email" placeholder="you@email.com"></div>';
    html += '<div class="form-row"><label>Password</label><input type="password" id="auth-pass" placeholder="••••••••"></div>';
    html += '<button class="submit-btn" id="auth-btn" onclick="doLogin()">Log In →</button>';
  } else {
    html += '<h3>Join SkillSwap</h3><p class="modal-sub">Free to join. Earn or hire in minutes.</p>';
    html += '<div class="form-row"><label>Full Name</label><input type="text" id="auth-name" placeholder="Your name"></div>';
    html += '<div class="form-row"><label>Email</label><input type="email" id="auth-email" placeholder="you@email.com"></div>';
    html += '<div class="form-row"><label>Password</label><input type="password" id="auth-pass" placeholder="Min 6 characters"></div>';
    html += '<div class="form-row"><label>I am a...</label><select id="auth-role"><option value="client">Client / Company</option><option value="freelancer">Freelancer / Small Business</option></select></div>';
    html += '<button class="submit-btn" id="auth-btn" onclick="doSignup()">Create Free Account →</button>';
  }
  document.getElementById('modal-content').innerHTML = html;
}

function doLogin() {
  var email = document.getElementById('auth-email').value;
  var pass = document.getElementById('auth-pass').value;
  if (!email || !pass) { showToast('Please fill in all fields', 'error'); return; }
  var btn = document.getElementById('auth-btn');
  btn.disabled = true; btn.textContent = 'Logging in...';
  supabase.auth.signInWithPassword({ email: email, password: pass })
    .then(function(res) {
      if (res.error) { showToast(res.error.message, 'error'); btn.disabled = false; btn.textContent = 'Log In →'; }
      else { showToast('Welcome back!', 'success'); closeModal(); }
    });
}

function doSignup() {
  var name = document.getElementById('auth-name').value;
  var email = document.getElementById('auth-email').value;
  var pass = document.getElementById('auth-pass').value;
  var role = document.getElementById('auth-role').value;
  if (!name || !email || !pass) { showToast('Please fill in all fields', 'error'); return; }
  var btn = document.getElementById('auth-btn');
  btn.disabled = true; btn.textContent = 'Creating account...';
  supabase.auth.signUp({ email: email, password: pass, options: { data: { full_name: name } } })
    .then(function(res) {
      if (res.error) { showToast(res.error.message, 'error'); btn.disabled = false; btn.textContent = 'Create Free Account →'; return; }
      var uid = res.data.user.id;
      return supabase.from('profiles').update({ full_name: name, role: role }).eq('id', uid);
    })
    .then(function() {
      showToast('Account created! Check your email to confirm.', 'success');
      closeModal();
    })
    .catch(function(err) {
      showToast('Something went wrong.', 'error');
      var btn2 = document.getElementById('auth-btn');
      if (btn2) { btn2.disabled = false; btn2.textContent = 'Create Free Account →'; }
    });
}

function signOut() {
  supabase.auth.signOut().then(function() {
    showToast('Signed out.', 'success');
    switchTab('home');
  });
}

// ============================================================
// PROFILE
// ============================================================
function loadProfile(uid) {
  supabase.from('profiles').select('*').eq('id', uid).single()
    .then(function(res) {
      if (res.data) { currentProfile = res.data; updateNav(); }
    });
}

function renderProfile() {
  if (!currentUser) {
    document.getElementById('profile-content').innerHTML =
      '<div class="empty-state"><h3>Not logged in</h3><p>Please log in to view your profile.</p></div>';
    return;
  }
  var p = currentProfile;
  if (!p) { document.getElementById('profile-content').innerHTML = '<div class="loading">Loading...</div>'; return; }
  var initials = p.full_name ? p.full_name.split(' ').map(function(n) { return n[0]; }).join('') : '?';
  var colors = ['#2d3a8c','#7c2d92','#c93a08','#2d6a4f','#a35c00','#1a4a6b'];
  var color = colors[Math.abs(p.id.charCodeAt(0)) % colors.length];
  var roleLabel = p.role === 'freelancer' ? 'Freelancer' : 'Client';
  var roleClass = p.role === 'freelancer' ? 'role-freelancer' : 'role-client';

  var html = '<div class="profile-view">';
  html += '<div class="profile-header">';
  html += '<div class="profile-avatar" style="background:' + color + '">' + initials + '</div>';
  html += '<div class="profile-info"><h2>' + (p.full_name || 'No name') + '</h2>';
  html += '<p>' + p.email + '</p>';
  html += '<span class="role-badge ' + roleClass + '">' + roleLabel + '</span></div>';
  html += '</div>';

  html += '<div class="form-row"><label>Full Name</label><input type="text" id="p-name" value="' + (p.full_name || '') + '"></div>';
  html += '<div class="form-row"><label>Bio</label><textarea id="p-bio" placeholder="Tell clients about yourself...">' + (p.bio || '') + '</textarea></div>';

if (p.role === ‘freelancer’) {
html += ‘<div class="form-grid">’;
html += ‘<div class="form-row"><label>Hourly Rate ($)</label><input type="number" id="p-rate" value="' + (p.hourly_rate || '') + '" placeholder="75"></div>’;
html += ‘<div class="form-row"><label>Location</label><input type="text" id="p-location" value="' + (p.location || '') + '" placeholder="New York, USA"></div>’;
html += ‘</div>’;
html += ‘<div class="form-row"><label>Skills (comma separated)</label><input type="text" id="p-skills" value="' + (p.skills ? p.skills.join(', ') : '') + '" placeholder="React, Figma, SEO"></div>’;
}
html += ‘<button class="submit-btn" onclick="saveProfile()">Save Profile →</button>’;
html += ‘</div>’;
document.getElementById(‘profile-content’).innerHTML = html;
}

function saveProfile() {
if (!currentUser) return;
var updates = {
full_name: document.getElementById(‘p-name’).value,
bio: document.getElementById(‘p-bio’).value
};
var rateEl = document.getElementById(‘p-rate’);
var locEl = document.getElementById(‘p-location’);
var skillsEl = document.getElementById(‘p-skills’);
if (rateEl) updates.hourly_rate = parseFloat(rateEl.value) || null;
if (locEl) updates.location = locEl.value;
if (skillsEl) updates.skills = skillsEl.value.split(’,’).map(function(s) { return s.trim(); }).filter(Boolean);

supabase.from(‘profiles’).update(updates).eq(‘id’, currentUser.id)
.then(function(res) {
if (res.error) showToast(‘Error saving profile.’, ‘error’);
else { currentProfile = Object.assign({}, currentProfile, updates); updateNav(); showToast(‘Profile saved!’, ‘success’); }
});
}

// ============================================================
// JOBS
// ============================================================
function loadJobs() {
supabase.from(‘jobs’).select(’*, profiles(full_name)’).eq(‘status’, ‘open’).order(‘created_at’, { ascending: false })
.then(function(res) {
var g = document.getElementById(‘jobs-grid’);
if (res.error || !res.data || res.data.length === 0) {
g.innerHTML = ‘<div class="empty-state"><h3>No jobs yet</h3><p>Be the first to post one!</p></div>’;
return;
}
var html = ‘’;
for (var i = 0; i < res.data.length; i++) {
var j = res.data[i];
var deadline = j.deadline ? new Date(j.deadline).toLocaleDateString() : ‘Open’;
html += ‘<div class="job-card" onclick="openBidModal(\'' + j.id + '\',\'' + escHtml(j.title) + '\',' + j.budget + ')">’;
html += ‘<div class="job-top"><span class="job-category">’ + (j.category || ‘General’) + ‘</span>’;
html += ‘<span class="job-budget">$’ + (j.budget || ‘?’) + ‘</span></div>’;
html += ‘<div class="job-title">’ + escHtml(j.title) + ‘</div>’;
html += ‘<div class="job-desc">’ + escHtml((j.description || ‘’).substring(0, 120)) + ‘…</div>’;
html += ‘<div class="job-footer"><div class="job-meta">Deadline: <strong>’ + deadline + ‘</strong></div>’;
if (j.urgent) html += ‘<span class="urgent-tag">Urgent</span>’;
else html += ‘<button class="bid-btn">Place Bid →</button>’;
html += ‘</div></div>’;
}
g.innerHTML = html;
});
}

function postJob() {
if (!currentUser) { openAuth(‘signup’); showToast(‘Please create an account to post a job.’, ‘error’); return; }
var title = document.getElementById(‘job-title’).value;
var cat = document.getElementById(‘job-cat’).value;
var desc = document.getElementById(‘job-desc’).value;
var budget = parseFloat(document.getElementById(‘job-budget’).value);
var deadline = document.getElementById(‘job-deadline’).value;
var urgent = document.getElementById(‘job-urgent’).checked;
if (!title || !cat || !desc || !budget) { showToast(‘Please fill in all required fields.’, ‘error’); return; }
var btn = document.getElementById(‘post-btn’);
btn.disabled = true; btn.textContent = ‘Posting…’;
supabase.from(‘jobs’).insert([{
client_id: currentUser.id,
title: title, category: cat, description: desc,
budget: budget, deadline: deadline || null, urgent: urgent, status: ‘open’
}]).then(function(res) {
if (res.error) { showToast(’Error posting job: ’ + res.error.message, ‘error’); btn.disabled = false; btn.textContent = ‘Post Job — It's Free →’; }
else {
showToast(‘Job posted! Bids incoming soon.’, ‘success’);
document.getElementById(‘job-title’).value = ‘’;
document.getElementById(‘job-desc’).value = ‘’;
document.getElementById(‘job-budget’).value = ‘’;
document.getElementById(‘job-cat’).value = ‘’;
btn.disabled = false; btn.textContent = ‘Post Job — It's Free →’;
setTimeout(function() { switchTab(‘jobs’); }, 1500);
}
});
}

// ============================================================
// FREELANCERS
// ============================================================
function loadFreelancers() {
supabase.from(‘profiles’).select(’*’).eq(‘role’, ‘freelancer’).order(‘created_at’, { ascending: false })
.then(function(res) {
var g = document.getElementById(‘freelancers-grid’);
if (res.error || !res.data || res.data.length === 0) {
g.innerHTML = ‘<div class="empty-state"><h3>No freelancers yet</h3><p>Sign up as a freelancer to be listed here.</p></div>’;
return;
}
var colors = [’#2d3a8c’,’#7c2d92’,’#c93a08’,’#2d6a4f’,’#a35c00’,’#1a4a6b’];
var html = ‘’;
for (var i = 0; i < res.data.length; i++) {
var f = res.data[i];
var initials = f.full_name ? f.full_name.split(’ ‘).map(function(n) { return n[0]; }).join(’’) : ‘?’;
var color = colors[i % colors.length];
var skills = f.skills && f.skills.length ? f.skills.slice(0, 3) : [‘Freelancer’];
var tagsHtml = ‘’;
for (var t = 0; t < skills.length; t++) tagsHtml += ‘<span class="tag">’ + escHtml(skills[t]) + ‘</span>’;
html += ‘<div class="freelancer-card">’;
html += ‘<div class="avatar" style="background:' + color + '">’ + initials + ‘</div>’;
html += ‘<div class="freelancer-name">’ + escHtml(f.full_name || ‘Anonymous’) + ‘</div>’;
html += ‘<div class="freelancer-title">’ + escHtml(f.bio ? f.bio.substring(0, 50) : ‘Freelancer’) + ‘</div>’;
html += ‘<div class="freelancer-tags">’ + tagsHtml + ‘</div>’;
if (f.hourly_rate) html += ‘<div class="freelancer-rate">$’ + f.hourly_rate + ‘/hr</div>’;
html += ‘<button class="hire-btn" onclick="openHireModal(\'' + f.id + '\',\'' + escHtml(f.full_name || 'Freelancer') + '\')">Hire ’ + escHtml((f.full_name || ‘Freelancer’).split(’ ‘)[0]) + ’ →</button>’;
html += ‘</div>’;
}
g.innerHTML = html;
});
}

// ============================================================
// BID MODAL
// ============================================================
function openBidModal(jobId, jobTitle, budget) {
if (!currentUser) { openAuth(‘signup’); return; }
var fee = (budget * 0.10).toFixed(2);
var total = (budget * 1.10).toFixed(2);
var html = ‘<h3>’ + jobTitle + ‘</h3>’;
html += ‘<p class="modal-sub">Budget: <strong>$’ + budget + ‘</strong></p>’;
html += ‘<div class="form-row"><label>Your Bid ($)</label><input type="number" id="bid-amount" placeholder="' + budget + '"></div>’;
html += ‘<div class="form-row"><label>Cover Letter</label><textarea id="bid-letter" placeholder="Why are you the best fit?"></textarea></div>’;
html += ‘<p class="fee-note">10% platform fee applies upon acceptance.</p>’;
html += ‘<button class="submit-btn" onclick="submitBid(\'' + jobId + '\')">Submit Bid →</button>’;
document.getElementById(‘modal-content’).innerHTML = html;
document.getElementById(‘modal-overlay’).classList.add(‘open’);
}

function submitBid(jobId) {
var amount = parseFloat(document.getElementById(‘bid-amount’).value);
var letter = document.getElementById(‘bid-letter’).value;
if (!amount) { showToast(‘Please enter your bid amount.’, ‘error’); return; }
supabase.from(‘bids’).insert([{
job_id: jobId,
freelancer_id: currentUser.id,
amount: amount,
cover_letter: letter,
status: ‘pending’
}]).then(function(res) {
if (res.error) showToast(’Error: ’ + (res.error.message.includes(‘unique’) ? ‘You already bid on this job.’ : res.error.message), ‘error’);
else { showToast(‘Bid submitted! Good luck 🎯’, ‘success’); closeModal(); }
});
}

// ============================================================
// HIRE MODAL + STRIPE PAYMENT
// ============================================================
function openHireModal(freelancerId, name) {
if (!currentUser) { openAuth(‘signup’); return; }
var html = ’<h3>Hire ’ + name + ‘</h3>’;
html += ‘<p class="modal-sub">Payment is held in escrow and released when work is done.</p>’;
html += ‘<div class="form-row"><label>Job Amount ($)</label><input type="number" id="hire-amount" placeholder="500" oninput="updateFeeDisplay()"></div>’;
html += ‘<p class="fee-note" id="fee-display">Platform fee (10%) will be added at checkout.</p>’;
html += ‘<div class="form-row"><label class="stripe-label">Card Details</label><div id="stripe-card-element"></div></div>’;
html += ‘<div class="form-row"><label>Message</label><textarea id="hire-msg" placeholder="Describe the project..."></textarea></div>’;
html += ‘<button class="submit-btn" id="hire-btn" onclick="processPayment(\'' + freelancerId + '\')">Pay & Hire ’ + name.split(’ ‘)[0] + ’ →</button>’;
document.getElementById(‘modal-content’).innerHTML = html;
document.getElementById(‘modal-overlay’).classList.add(‘open’);

var elements = stripe.elements();
window._cardElement = elements.create(‘card’, {
style: {
base: { fontFamily: ‘“DM Sans”, sans-serif’, fontSize: ‘15px’, color: ‘#0a0a0f’ }
}
});
window._cardElement.mount(’#stripe-card-element’);
window._hireFreelancerId = freelancerId;
}

function updateFeeDisplay() {
var amt = parseFloat(document.getElementById(‘hire-amount’).value);
if (amt) {
var fee = (amt * 0.10).toFixed(2);
var total = (amt * 1.10).toFixed(2);
document.getElementById(‘fee-display’).textContent = ‘10% fee: $’ + fee + ’ — Total charged: $’ + total;
}
}

function processPayment(freelancerId) {
var amount = parseFloat(document.getElementById(‘hire-amount’).value);
if (!amount) { showToast(‘Please enter the job amount.’, ‘error’); return; }
var btn = document.getElementById(‘hire-btn’);
btn.disabled = true; btn.textContent = ‘Processing…’;
// In production: call your backend to create a PaymentIntent
// The backend returns a client_secret, then you confirm with stripe.confirmCardPayment
// For MVP demo, we simulate and log the payment record
var platformFee = amount * 0.10;
supabase.from(‘payments’).insert([{
client_id: currentUser.id,
freelancer_id: freelancerId,
amount: amount,
platform_fee: platformFee,
stripe_payment_intent_id: ‘pi_demo_’ + Date.now(),
status: ‘escrowed’
}]).then(function(res) {
if (res.error) { showToast(’Payment error: ’ + res.error.message, ‘error’); btn.disabled = false; btn.textContent = ‘Pay & Hire →’; }
else { showToast(‘Payment escrowed! Freelancer has been notified.’, ‘success’); closeModal(); }
});
}

// ============================================================
// UTILS
// ============================================================
function escHtml(str) {
if (!str) return ‘’;
return String(str).replace(/&/g,’&’).replace(/</g,’<’).replace(/>/g,’>’).replace(/”/g,’"’);
}

function showToast(msg, type) {
var t = document.getElementById(‘toast’);
t.textContent = msg;
t.className = ’toast ’ + (type || ‘’);
t.classList.add(‘show’);
setTimeout(function() { t.classList.remove(‘show’); }, 3500);
}

function closeModal() {
document.getElementById(‘modal-overlay’).classList.remove(‘open’);
}

function handleOverlayClick(e) {
if (e.target === document.getElementById(‘modal-overlay’)) closeModal();
}
</script>

</body>
</html>
<!DOCTYPE html>

<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>SkillSwap — Client Dashboard</title>
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=IBM+Plex+Mono:wght@400;500&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>
<style>
  :root {
    --bg: #0d0d0d;
    --surface: #141414;
    --surface2: #1a1a1a;
    --border: #262626;
    --border2: #2e2e2e;
    --text: #f0ede8;
    --muted: #5a5a5a;
    --muted2: #3a3a3a;
    --accent: #e8440a;
    --accent-dim: rgba(232,68,10,0.12);
    --green: #22c55e;
    --green-dim: rgba(34,197,94,0.1);
    --yellow: #f59e0b;
    --yellow-dim: rgba(245,158,11,0.1);
    --blue: #3b82f6;
    --blue-dim: rgba(59,130,246,0.1);
    --red: #ef4444;
    --red-dim: rgba(239,68,68,0.1);
  }
  * { margin:0; padding:0; box-sizing:border-box; }
  body {
    font-family:'DM Sans',sans-serif;
    background:var(--bg);
    color:var(--text);
    min-height:100vh;
  }

/* SIDEBAR */
.layout { display:flex; min-height:100vh; }
.sidebar {
width:220px; flex-shrink:0;
background:var(–surface);
border-right:1px solid var(–border);
display:flex; flex-direction:column;
position:fixed; top:0; left:0; bottom:0;
z-index:50;
}
.sidebar-logo {
padding:24px 20px 20px;
border-bottom:1px solid var(–border);
}
.logo-text {
font-family:‘Syne’,sans-serif; font-weight:800; font-size:1.25rem;
color:var(–text); letter-spacing:-0.5px;
}
.logo-text span { color:var(–accent); }
.logo-sub { font-family:‘IBM Plex Mono’,monospace; font-size:0.62rem; color:var(–muted); margin-top:2px; letter-spacing:1px; }
.sidebar-nav { padding:16px 0; flex:1; }
.nav-item {
display:flex; align-items:center; gap:10px;
padding:10px 20px; cursor:pointer;
font-family:‘Syne’,sans-serif; font-weight:600; font-size:0.8rem;
color:var(–muted); transition:all 0.15s; letter-spacing:0.3px;
border-left:2px solid transparent;
}
.nav-item:hover { color:var(–text); background:var(–surface2); }
.nav-item.active { color:var(–text); border-left-color:var(–accent); background:var(–surface2); }
.nav-icon { font-size:1rem; width:20px; text-align:center; }
.sidebar-footer {
padding:16px 20px;
border-top:1px solid var(–border);
}
.user-chip {
display:flex; align-items:center; gap:10px;
}
.user-dot {
width:32px; height:32px; border-radius:50%;
background:var(–accent); display:flex; align-items:center; justify-content:center;
font-family:‘Syne’,sans-serif; font-weight:800; font-size:0.75rem; color:#fff;
flex-shrink:0;
}
.user-name { font-family:‘Syne’,sans-serif; font-weight:700; font-size:0.78rem; color:var(–text); }
.user-email { font-size:0.68rem; color:var(–muted); margin-top:1px; }
.sign-out-btn {
margin-top:12px; width:100%;
background:transparent; border:1px solid var(–border2);
color:var(–muted); padding:8px; border-radius:6px;
font-family:‘Syne’,sans-serif; font-weight:700; font-size:0.72rem;
cursor:pointer; transition:all 0.15s; letter-spacing:0.5px;
}
.sign-out-btn:hover { border-color:var(–accent); color:var(–accent); }

/* MAIN */
.main { margin-left:220px; flex:1; }
.topbar {
display:flex; align-items:center; justify-content:space-between;
padding:20px 32px;
border-bottom:1px solid var(–border);
background:var(–surface);
position:sticky; top:0; z-index:40;
}
.topbar-title {
font-family:‘Syne’,sans-serif; font-weight:800; font-size:1.1rem; letter-spacing:-0.3px;
}
.topbar-sub { font-family:‘IBM Plex Mono’,monospace; font-size:0.68rem; color:var(–muted); margin-top:2px; }
.post-job-btn {
background:var(–accent); color:#fff;
padding:10px 20px; border-radius:8px; border:none;
font-family:‘Syne’,sans-serif; font-weight:700; font-size:0.8rem;
cursor:pointer; transition:all 0.15s;
}
.post-job-btn:hover { background:#c93a08; }

/* VIEWS */
.view { display:none; padding:32px; }
.view.active { display:block; }

/* STAT CARDS */
.stats-row { display:grid; grid-template-columns:repeat(4,1fr); gap:16px; margin-bottom:32px; }
.stat-card {
background:var(–surface); border:1px solid var(–border);
border-radius:12px; padding:20px;
position:relative; overflow:hidden;
}
.stat-card::after {
content:’’; position:absolute; top:0; left:0; right:0; height:2px;
}
.stat-card.green::after { background:var(–green); }
.stat-card.orange::after { background:var(–accent); }
.stat-card.yellow::after { background:var(–yellow); }
.stat-card.blue::after { background:var(–blue); }
.stat-label { font-family:‘IBM Plex Mono’,monospace; font-size:0.65rem; color:var(–muted); letter-spacing:1px; text-transform:uppercase; margin-bottom:10px; }
.stat-value { font-family:‘Syne’,sans-serif; font-weight:800; font-size:1.8rem; color:var(–text); line-height:1; }
.stat-value.green { color:var(–green); }
.stat-value.orange { color:var(–accent); }
.stat-value.yellow { color:var(–yellow); }
.stat-value.blue { color:var(–blue); }
.stat-change { font-size:0.72rem; color:var(–muted); margin-top:6px; }

/* SECTION */
.section-title {
font-family:‘Syne’,sans-serif; font-weight:800; font-size:0.85rem;
letter-spacing:1px; text-transform:uppercase; color:var(–muted);
margin-bottom:16px;
}

/* JOBS TABLE */
.table-wrap {
background:var(–surface); border:1px solid var(–border);
border-radius:12px; overflow:hidden; margin-bottom:32px;
}
.table-header {
display:grid; grid-template-columns:2fr 1fr 1fr 1fr 1fr;
padding:12px 20px;
background:var(–surface2);
border-bottom:1px solid var(–border);
font-family:‘IBM Plex Mono’,monospace; font-size:0.65rem;
color:var(–muted); letter-spacing:1px; text-transform:uppercase;
}
.table-row {
display:grid; grid-template-columns:2fr 1fr 1fr 1fr 1fr;
padding:16px 20px;
border-bottom:1px solid var(–border);
align-items:center;
transition:background 0.15s;
}
.table-row:last-child { border-bottom:none; }
.table-row:hover { background:var(–surface2); }
.job-title-cell { font-family:‘Syne’,sans-serif; font-weight:700; font-size:0.88rem; }
.job-cat-cell { font-family:‘IBM Plex Mono’,monospace; font-size:0.72rem; color:var(–muted); }
.budget-cell { font-family:‘Syne’,sans-serif; font-weight:700; font-size:0.88rem; color:var(–green); }
.date-cell { font-family:‘IBM Plex Mono’,monospace; font-size:0.72rem; color:var(–muted); }

/* STATUS BADGES */
.badge {
display:inline-flex; align-items:center; gap:5px;
padding:4px 10px; border-radius:20px;
font-family:‘IBM Plex Mono’,monospace; font-size:0.65rem;
font-weight:500; letter-spacing:0.5px; white-space:nowrap;
}
.badge::before { content:’’; width:5px; height:5px; border-radius:50%; flex-shrink:0; }
.badge-open { background:var(–blue-dim); color:var(–blue); }
.badge-open::before { background:var(–blue); }
.badge-progress { background:var(–yellow-dim); color:var(–yellow); }
.badge-progress::before { background:var(–yellow); }
.badge-escrowed { background:var(–accent-dim); color:var(–accent); }
.badge-escrowed::before { background:var(–accent); }
.badge-completed { background:var(–green-dim); color:var(–green); }
.badge-completed::before { background:var(–green); }
.badge-cancelled { background:var(–red-dim); color:var(–red); }
.badge-cancelled::before { background:var(–red); }

/* PAYMENTS TABLE */
.payment-header {
display:grid; grid-template-columns:2fr 1fr 1fr 1fr 1fr;
padding:12px 20px;
background:var(–surface2);
border-bottom:1px solid var(–border);
font-family:‘IBM Plex Mono’,monospace; font-size:0.65rem;
color:var(–muted); letter-spacing:1px; text-transform:uppercase;
}
.payment-row {
display:grid; grid-template-columns:2fr 1fr 1fr 1fr 1fr;
padding:16px 20px;
border-bottom:1px solid var(–border);
align-items:center;
transition:background 0.15s;
}
.payment-row:last-child { border-bottom:none; }
.payment-row:hover { background:var(–surface2); }

/* RELEASE BUTTON */
.release-btn {
background:var(–green-dim); color:var(–green);
border:1px solid rgba(34,197,94,0.2);
padding:7px 14px; border-radius:6px;
font-family:‘Syne’,sans-serif; font-weight:700; font-size:0.72rem;
cursor:pointer; transition:all 0.15s; white-space:nowrap;
}
.release-btn:hover { background:var(–green); color:#000; }
.release-btn:disabled { opacity:0.4; cursor:not-allowed; }

/* BIDS SECTION */
.bids-grid { display:grid; grid-template-columns:repeat(auto-fill,minmax(300px,1fr)); gap:16px; margin-bottom:32px; }
.bid-card {
background:var(–surface); border:1px solid var(–border);
border-radius:12px; padding:20px;
}
.bid-card-top { display:flex; justify-content:space-between; align-items:flex-start; margin-bottom:12px; }
.bid-freelancer { font-family:‘Syne’,sans-serif; font-weight:700; font-size:0.9rem; }
.bid-amount { font-family:‘Syne’,sans-serif; font-weight:800; font-size:1.1rem; color:var(–green); }
.bid-job { font-family:‘IBM Plex Mono’,monospace; font-size:0.7rem; color:var(–muted); margin-bottom:10px; }
.bid-letter { font-size:0.82rem; color:rgba(240,237,232,0.6); line-height:1.6; margin-bottom:14px; font-style:italic; }
.bid-actions { display:flex; gap:8px; }
.accept-btn {
flex:1; background:var(–green-dim); color:var(–green);
border:1px solid rgba(34,197,94,0.2); padding:8px;
border-radius:6px; font-family:‘Syne’,sans-serif; font-weight:700; font-size:0.75rem;
cursor:pointer; transition:all 0.15s;
}
.accept-btn:hover { background:var(–green); color:#000; }
.reject-btn {
flex:1; background:var(–red-dim); color:var(–red);
border:1px solid rgba(239,68,68,0.2); padding:8px;
border-radius:6px; font-family:‘Syne’,sans-serif; font-weight:700; font-size:0.75rem;
cursor:pointer; transition:all 0.15s;
}
.reject-btn:hover { background:var(–red); color:#fff; }

/* EMPTY STATE */
.empty {
padding:60px 20px; text-align:center;
}
.empty-icon { font-size:2.5rem; margin-bottom:12px; opacity:0.3; }
.empty h3 { font-family:‘Syne’,sans-serif; font-weight:800; font-size:1rem; color:var(–muted); margin-bottom:6px; }
.empty p { font-size:0.82rem; color:var(–muted2); }

/* LOADING */
.loading {
padding:40px; text-align:center;
font-family:‘IBM Plex Mono’,monospace; font-size:0.72rem;
color:var(–muted); letter-spacing:2px; text-transform:uppercase;
}
@keyframes pulse { 0%,100%{opacity:1} 50%{opacity:0.3} }
.loading { animation:pulse 1.5s infinite; }

/* LOGIN SCREEN */
.login-screen {
display:flex; align-items:center; justify-content:center;
min-height:100vh; background:var(–bg);
padding:20px;
}
.login-box {
background:var(–surface); border:1px solid var(–border);
border-radius:16px; padding:40px; width:100%; max-width:400px;
}
.login-logo { font-family:‘Syne’,sans-serif; font-weight:800; font-size:1.6rem; margin-bottom:4px; }
.login-logo span { color:var(–accent); }
.login-sub { font-family:‘IBM Plex Mono’,monospace; font-size:0.7rem; color:var(–muted); margin-bottom:32px; letter-spacing:1px; }
.field { margin-bottom:18px; }
.field label { display:block; font-family:‘IBM Plex Mono’,monospace; font-size:0.68rem; color:var(–muted); letter-spacing:1px; text-transform:uppercase; margin-bottom:8px; }
.field input {
width:100%; padding:12px 14px;
background:var(–surface2); border:1px solid var(–border2);
border-radius:8px; color:var(–text);
font-family:‘DM Sans’,sans-serif; font-size:0.95rem;
outline:none; transition:border-color 0.15s;
}
.field input:focus { border-color:var(–accent); }
.login-btn {
width:100%; padding:14px;
background:var(–accent); color:#fff; border:none; border-radius:8px;
font-family:‘Syne’,sans-serif; font-weight:800; font-size:0.9rem;
cursor:pointer; transition:all 0.15s; margin-top:8px;
}
.login-btn:hover { background:#c93a08; }
.login-btn:disabled { background:var(–muted2); cursor:not-allowed; }
.login-err { font-size:0.8rem; color:var(–accent); margin-top:10px; text-align:center; min-height:20px; }

/* TOAST */
.toast {
position:fixed; bottom:24px; right:24px;
background:var(–surface); border:1px solid var(–border2);
color:var(–text); padding:14px 18px; border-radius:10px;
font-family:‘IBM Plex Mono’,monospace; font-size:0.75rem;
z-index:999; transform:translateY(80px); opacity:0;
transition:all 0.3s; max-width:300px; letter-spacing:0.3px;
}
.toast.show { transform:translateY(0); opacity:1; }
.toast.success { border-left:3px solid var(–green); }
.toast.error { border-left:3px solid var(–accent); }

/* MODAL */
.modal-overlay {
display:none; position:fixed; inset:0;
background:rgba(0,0,0,0.7); z-index:200;
align-items:center; justify-content:center; padding:20px;
}
.modal-overlay.open { display:flex; }
.modal {
background:var(–surface); border:1px solid var(–border2);
border-radius:16px; padding:32px; max-width:440px; width:100%;
position:relative;
}
.modal-close { position:absolute; top:14px; right:16px; background:none; border:none; color:var(–muted); font-size:1.3rem; cursor:pointer; }
.modal h3 { font-family:‘Syne’,sans-serif; font-weight:800; font-size:1.1rem; margin-bottom:6px; }
.modal p { font-size:0.85rem; color:rgba(240,237,232,0.5); margin-bottom:20px; line-height:1.6; }
.modal-actions { display:flex; gap:10px; }
.modal-confirm {
flex:1; background:var(–green); color:#000;
padding:12px; border-radius:8px; border:none;
font-family:‘Syne’,sans-serif; font-weight:800; font-size:0.85rem;
cursor:pointer; transition:all 0.15s;
}
.modal-confirm:hover { background:#16a34a; }
.modal-cancel {
flex:1; background:transparent; color:var(–muted);
padding:12px; border-radius:8px; border:1px solid var(–border2);
font-family:‘Syne’,sans-serif; font-weight:700; font-size:0.85rem;
cursor:pointer; transition:all 0.15s;
}
.modal-cancel:hover { color:var(–text); border-color:var(–text); }

@media(max-width:768px){
.sidebar { display:none; }
.main { margin-left:0; }
.stats-row { grid-template-columns:1fr 1fr; }
.table-header, .table-row { grid-template-columns:1fr 1fr; }
.table-header span:nth-child(n+3), .table-row span:nth-child(n+3) { display:none; }
.payment-header, .payment-row { grid-template-columns:1fr 1fr 1fr; }
.payment-header span:nth-child(n+4), .payment-row span:nth-child(n+4) { display:none; }
.view { padding:20px; }
}
</style>

</head>
<body>

<!-- LOGIN SCREEN -->

<div id="login-screen" class="login-screen">
  <div class="login-box">
    <div class="login-logo">Skill<span>Swap</span></div>
    <div class="login-sub">CLIENT DASHBOARD</div>
    <div class="field"><label>Email</label><input type="email" id="login-email" placeholder="you@email.com"></div>
    <div class="field"><label>Password</label><input type="password" id="login-pass" placeholder="••••••••" onkeydown="if(event.key==='Enter')doLogin()"></div>
    <button class="login-btn" id="login-btn" onclick="doLogin()">Access Dashboard →</button>
    <div class="login-err" id="login-err"></div>
  </div>
</div>

<!-- DASHBOARD -->

<div id="dashboard" style="display:none">
  <div class="layout">

```
<!-- SIDEBAR -->
<aside class="sidebar">
  <div class="sidebar-logo">
    <div class="logo-text">Skill<span>Swap</span></div>
    <div class="logo-sub">CLIENT DASHBOARD</div>
  </div>
  <nav class="sidebar-nav">
    <div class="nav-item active" onclick="showView('overview')"><span class="nav-icon">◈</span>Overview</div>
    <div class="nav-item" onclick="showView('jobs')"><span class="nav-icon">◻</span>My Jobs</div>
    <div class="nav-item" onclick="showView('bids')"><span class="nav-icon">◎</span>Bids Received</div>
    <div class="nav-item" onclick="showView('payments')"><span class="nav-icon">◆</span>Payments</div>
  </nav>
  <div class="sidebar-footer">
    <div class="user-chip">
      <div class="user-dot" id="user-dot">?</div>
      <div>
        <div class="user-name" id="user-name-display">Loading...</div>
        <div class="user-email" id="user-email-display"></div>
      </div>
    </div>
    <button class="sign-out-btn" onclick="signOut()">SIGN OUT</button>
  </div>
</aside>

<!-- MAIN -->
<main class="main">
  <div class="topbar">
    <div>
      <div class="topbar-title" id="topbar-title">Overview</div>
      <div class="topbar-sub" id="topbar-sub">Welcome back</div>
    </div>
    <button class="post-job-btn" onclick="window.open('skillswap-live.html#post','_blank')">+ Post New Job</button>
  </div>

  <!-- OVERVIEW -->
  <div id="view-overview" class="view active">
    <div class="stats-row">
      <div class="stat-card orange">
        <div class="stat-label">Active Jobs</div>
        <div class="stat-value orange" id="stat-active">—</div>
        <div class="stat-change">open right now</div>
      </div>
      <div class="stat-card yellow">
        <div class="stat-label">Bids Received</div>
        <div class="stat-value yellow" id="stat-bids">—</div>
        <div class="stat-change">awaiting review</div>
      </div>
      <div class="stat-card blue">
        <div class="stat-label">In Escrow</div>
        <div class="stat-value blue" id="stat-escrow">—</div>
        <div class="stat-change">held securely</div>
      </div>
      <div class="stat-card green">
        <div class="stat-label">Total Spent</div>
        <div class="stat-value green" id="stat-spent">—</div>
        <div class="stat-change">completed jobs</div>
      </div>
    </div>

    <div class="section-title">Recent Jobs</div>
    <div class="table-wrap">
      <div class="table-header">
        <span>Job Title</span><span>Category</span><span>Budget</span><span>Status</span><span>Posted</span>
      </div>
      <div id="overview-jobs"><div class="loading">Loading...</div></div>
    </div>

    <div class="section-title">Pending Bids</div>
    <div class="table-wrap">
      <div class="table-header" style="grid-template-columns:2fr 1fr 1fr 1fr">
        <span>Job</span><span>Freelancer</span><span>Amount</span><span>Action</span>
      </div>
      <div id="overview-bids"><div class="loading">Loading...</div></div>
    </div>
  </div>

  <!-- MY JOBS -->
  <div id="view-jobs" class="view">
    <div class="table-wrap">
      <div class="table-header">
        <span>Job Title</span><span>Category</span><span>Budget</span><span>Status</span><span>Posted</span>
      </div>
      <div id="jobs-table"><div class="loading">Loading...</div></div>
    </div>
  </div>

  <!-- BIDS -->
  <div id="view-bids" class="view">
    <div id="bids-container"><div class="loading">Loading...</div></div>
  </div>

  <!-- PAYMENTS -->
  <div id="view-payments" class="view">
    <div class="table-wrap">
      <div class="payment-header">
        <span>Freelancer</span><span>Amount</span><span>Fee</span><span>Status</span><span>Action</span>
      </div>
      <div id="payments-table"><div class="loading">Loading...</div></div>
    </div>
  </div>

</main>
```

  </div>
</div>

<!-- CONFIRM MODAL -->

<div class="modal-overlay" id="modal-overlay">
  <div class="modal">
    <button class="modal-close" onclick="closeModal()">×</button>
    <div id="modal-content"></div>
  </div>
</div>

<!-- TOAST -->

<div class="toast" id="toast"></div>

<script>
// ============================================================
// CONFIG — same as skillswap-live.html
// ============================================================
var SUPABASE_URL = 'https://cowwlpiatpyiadrllkzr.supabase.co';
var SUPABASE_ANON_KEY = 'YOUR_SUPABASE_ANON_KEY'; // paste your key here

var supabase = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
var currentUser = null;
var currentProfile = null;
var pendingReleaseId = null;

// ============================================================
// INIT
// ============================================================
supabase.auth.getSession().then(function(res) {
  if (res.data && res.data.session) {
    currentUser = res.data.session.user;
    bootDashboard();
  }
});

supabase.auth.onAuthStateChange(function(event, session) {
  if (session && !currentUser) {
    currentUser = session.user;
    bootDashboard();
  } else if (!session) {
    currentUser = null;
    document.getElementById('dashboard').style.display = 'none';
    document.getElementById('login-screen').style.display = 'flex';
  }
});

// ============================================================
// AUTH
// ============================================================
function doLogin() {
  var email = document.getElementById('login-email').value;
  var pass = document.getElementById('login-pass').value;
  var err = document.getElementById('login-err');
  var btn = document.getElementById('login-btn');
  if (!email || !pass) { err.textContent = 'Please enter your email and password.'; return; }
  btn.disabled = true; btn.textContent = 'Signing in...';
  supabase.auth.signInWithPassword({ email: email, password: pass })
    .then(function(res) {
      if (res.error) {
        err.textContent = res.error.message;
        btn.disabled = false; btn.textContent = 'Access Dashboard →';
      }
      // bootDashboard called via onAuthStateChange
    });
}

function signOut() {
  supabase.auth.signOut().then(function() {
    currentUser = null; currentProfile = null;
  });
}

// ============================================================
// BOOT
// ============================================================
function bootDashboard() {
  document.getElementById('login-screen').style.display = 'none';
  document.getElementById('dashboard').style.display = 'block';
  loadProfile();
  loadAllData();
}

function loadProfile() {
  supabase.from('profiles').select('*').eq('id', currentUser.id).single()
    .then(function(res) {
      if (res.data) {
        currentProfile = res.data;
        var name = res.data.full_name || currentUser.email;
        var initials = name.split(' ').map(function(n) { return n[0]; }).join('').substring(0,2).toUpperCase();
        document.getElementById('user-dot').textContent = initials;
        document.getElementById('user-name-display').textContent = name.split(' ')[0];
        document.getElementById('user-email-display').textContent = currentUser.email;
        document.getElementById('topbar-sub').textContent = 'Welcome back, ' + name.split(' ')[0];
      }
    });
}

// ============================================================
// LOAD ALL DATA
// ============================================================
function loadAllData() {
  loadStats();
  loadOverviewJobs();
  loadOverviewBids();
}

function loadStats() {
  // Active jobs
  supabase.from('jobs').select('id', { count:'exact' }).eq('client_id', currentUser.id).eq('status','open')
    .then(function(res) { document.getElementById('stat-active').textContent = res.count || 0; });

  // Pending bids on my jobs
  supabase.from('jobs').select('id').eq('client_id', currentUser.id)
    .then(function(jobsRes) {
      if (!jobsRes.data || jobsRes.data.length === 0) { document.getElementById('stat-bids').textContent = 0; return; }
      var ids = jobsRes.data.map(function(j) { return j.id; });
      supabase.from('bids').select('id', { count:'exact' }).in('job_id', ids).eq('status','pending')
        .then(function(res) { document.getElementById('stat-bids').textContent = res.count || 0; });
    });

  // Escrow + spent
  supabase.from('payments').select('amount, platform_fee, status').eq('client_id', currentUser.id)
    .then(function(res) {
      if (!res.data) return;
      var escrow = 0; var spent = 0;
      for (var i = 0; i < res.data.length; i++) {
        var p = res.data[i];
        var total = (p.amount || 0) + (p.platform_fee || 0);
        if (p.status === 'escrowed' || p.status === 'pending') escrow += total;
        if (p.status === 'released') spent += total;
      }
      document.getElementById('stat-escrow').textContent = '$' + escrow.toFixed(0);
      document.getElementById('stat-spent').textContent = '$' + spent.toFixed(0);
    });
}

function loadOverviewJobs() {
  supabase.from('jobs').select('*').eq('client_id', currentUser.id)
    .order('created_at', { ascending: false }).limit(5)
    .then(function(res) {
      renderJobsTable('overview-jobs', res.data);
    });
}

function loadOverviewBids() {
  supabase.from('jobs').select('id, title').eq('client_id', currentUser.id)
    .then(function(jobsRes) {
      if (!jobsRes.data || jobsRes.data.length === 0) {
        document.getElementById('overview-bids').innerHTML = '<div class="empty"><div class="empty-icon">◎</div><h3>No bids yet</h3><p>Post a job to start receiving bids.</p></div>';
        return;
      }
      var jobMap = {};
      for (var i = 0; i < jobsRes.data.length; i++) jobMap[jobsRes.data[i].id] = jobsRes.data[i].title;
      var ids = jobsRes.data.map(function(j) { return j.id; });
      supabase.from('bids').select('*, profiles(full_name)').in('job_id', ids).eq('status','pending').limit(5)
        .then(function(res) {
          if (!res.data || res.data.length === 0) {
            document.getElementById('overview-bids').innerHTML = '<div class="empty"><div class="empty-icon">◎</div><h3>No pending bids</h3><p>Bids on your jobs will appear here.</p></div>';
            return;
          }
          var html = '';
          for (var i = 0; i < res.data.length; i++) {
            var b = res.data[i];
            var freelancerName = b.profiles ? b.profiles.full_name : 'Unknown';
            var jobTitle = jobMap[b.job_id] || 'Unknown Job';
            html += '<div class="payment-row" style="grid-template-columns:2fr 1fr 1fr 1fr">';
            html += '<span style="font-family:\'Syne\',sans-serif;font-weight:700;font-size:0.85rem">' + esc(jobTitle) + '</span>';
            html += '<span style="font-size:0.82rem;color:rgba(240,237,232,0.6)">' + esc(freelancerName) + '</span>';
            html += '<span style="font-family:\'Syne\',sans-serif;font-weight:700;color:var(--green)">$' + b.amount + '</span>';
            html += '<div style="display:flex;gap:6px">';
            html += '<button class="accept-btn" onclick="acceptBid(\'' + b.id + '\',\'' + b.job_id + '\')">Accept</button>';
            html += '<button class="reject-btn" onclick="rejectBid(\'' + b.id + '\')">Reject</button>';
            html += '</div>';
            html += '</div>';
          }
          document.getElementById('overview-bids').innerHTML = html;
        });
    });
}

// ============================================================
// VIEWS
// ============================================================
var viewTitles = { overview:'Overview', jobs:'My Jobs', bids:'Bids Received', payments:'Payments' };

function showView(name) {
  var views = ['overview','jobs','bids','payments'];
  var navItems = document.querySelectorAll('.nav-item');
  for (var i = 0; i < views.length; i++) {
    document.getElementById('view-' + views[i]).classList.remove('active');
    navItems[i].classList.remove('active');
  }
  document.getElementById('view-' + name).classList.add('active');
  var idx = views.indexOf(name);
  navItems[idx].classList.add('active');
  document.getElementById('topbar-title').textContent = viewTitles[name];

  if (name === 'jobs') loadJobsView();
  if (name === 'bids') loadBidsView();
  if (name === 'payments') loadPaymentsView();
}

// ============================================================
// JOBS VIEW
// ============================================================
function loadJobsView() {
  supabase.from('jobs').select('*').eq('client_id', currentUser.id)
    .order('created_at', { ascending: false })
    .then(function(res) { renderJobsTable('jobs-table', res.data); });
}

function renderJobsTable(containerId, data) {
  var el = document.getElementById(containerId);
  if (!data || data.length === 0) {
    el.innerHTML = '<div class="empty"><div class="empty-icon">◻</div><h3>No jobs yet</h3><p>Post your first job to get started.</p></div>';
    return;
  }
  var html = '';
  for (var i = 0; i < data.length; i++) {
    var j = data[i];
    var date = new Date(j.created_at).toLocaleDateString('en-US', { month:'short', day:'numeric' });
    var statusClass = 'badge-' + (j.status === 'in_progress' ? 'progress' : j.status);
    var statusLabel = j.status === 'in_progress' ? 'IN PROGRESS' : j.status.toUpperCase();
    html += '<div class="table-row">';
    html += '<span class="job-title-cell">' + esc(j.title) + (j.urgent ? ' <span style="font-size:0.65rem;color:var(--accent);font-family:\'IBM Plex Mono\',monospace"> URGENT</span>' : '') + '</span>';
    html += '<span class="job-cat-cell">' + esc(j.category || '—') + '</span>';
    html += '<span class="budget-cell">$' + (j.budget || '—') + '</span>';
    html += '<span><span class="badge ' + statusClass + '">' + statusLabel + '</span></span>';
    html += '<span class="date-cell">' + date + '</span>';
    html += '</div>';
  }
  el.innerHTML = html;
}

// ============================================================
// BIDS VIEW
// ============================================================
function loadBidsView() {
  supabase.from('jobs').select('id, title').eq('client_id', currentUser.id)
    .then(function(jobsRes) {
      if (!jobsRes.data || jobsRes.data.length === 0) {
        document.getElementById('bids-container').innerHTML = '<div class="empty"><div class="empty-icon">◎</div><h3>No bids yet</h3><p>Post jobs to start receiving bids from freelancers.</p></div>';
        return;
      }
      var jobMap = {};
      for (var i = 0; i < jobsRes.data.length; i++) jobMap[jobsRes.data[i].id] = jobsRes.data[i].title;
      var ids = jobsRes.data.map(function(j) { return j.id; });
      supabase.from('bids').select('*, profiles(full_name, bio, hourly_rate)').in('job_id', ids).order('created_at', { ascending: false })
        .then(function(res) {
          if (!res.data || res.data.length === 0) {
            document.getElementById('bids-container').innerHTML = '<div class="empty"><div class="empty-icon">◎</div><h3>No bids received</h3><p>Freelancers will bid on your jobs here.</p></div>';
            return;
          }
          var html = '<div class="bids-grid">';
          for (var i = 0; i < res.data.length; i++) {
            var b = res.data[i];
            var name = b.profiles ? b.profiles.full_name : 'Unknown Freelancer';
            var initials = name.split(' ').map(function(n) { return n[0]; }).join('').substring(0,2).toUpperCase();
            var colors = ['#2d3a8c','#7c2d92','#c93a08','#2d6a4f','#a35c00','#1a4a6b'];
            var color = colors[i % colors.length];
            var statusBadge = b.status === 'accepted' ? '<span class="badge badge-completed">ACCEPTED</span>' :
                              b.status === 'rejected' ? '<span class="badge badge-cancelled">REJECTED</span>' :
                              '<span class="badge badge-open">PENDING</span>';
            html += '<div class="bid-card">';
            html += '<div class="bid-card-top">';
            html += '<div style="display:flex;align-items:center;gap:10px">';
            html += '<div style="width:38px;height:38px;border-radius:50%;background:' + color + ';display:flex;align-items:center;justify-content:center;font-family:\'Syne\',sans-serif;font-weight:800;font-size:0.75rem;color:#fff;flex-shrink:0">' + initials + '</div>';
            html += '<div><div class="bid-freelancer">' + esc(name) + '</div>';
            html += '<div class="bid-job">' + esc(jobMap[b.job_id] || 'Unknown Job') + '</div></div>';
            html += '</div>';
            html += '<div style="text-align:right"><div class="bid-amount">$' + b.amount + '</div>' + statusBadge + '</div>';
            html += '</div>';
            if (b.cover_letter) html += '<div class="bid-letter">"' + esc(b.cover_letter.substring(0, 160)) + (b.cover_letter.length > 160 ? '...' : '') + '"</div>';
            if (b.status === 'pending') {
              html += '<div class="bid-actions">';
              html += '<button class="accept-btn" onclick="acceptBid(\'' + b.id + '\',\'' + b.job_id + '\')">✓ Accept</button>';
              html += '<button class="reject-btn" onclick="rejectBid(\'' + b.id + '\')">✕ Reject</button>';
              html += '</div>';
            }
            html += '</div>';
          }
          html += '</div>';
          document.getElementById('bids-container').innerHTML = html;
        });
    });
}

function acceptBid(bidId, jobId) {
  supabase.from('bids').update({ status: 'accepted' }).eq('id', bidId)
    .then(function(res) {
      if (res.error) { showToast('Error accepting bid', 'error'); return; }
      supabase.from('jobs').update({ status: 'in_progress' }).eq('id', jobId).then(function() {});
      showToast('Bid accepted! Job marked in progress.', 'success');
      loadBidsView(); loadStats();
    });
}

function rejectBid(bidId) {
  supabase.from('bids').update({ status: 'rejected' }).eq('id', bidId)
    .then(function(res) {
      if (res.error) { showToast('Error rejecting bid', 'error'); return; }
      showToast('Bid rejected.', 'success');
      loadBidsView(); loadStats();
    });
}

// ============================================================
// PAYMENTS VIEW
// ============================================================
function loadPaymentsView() {
  supabase.from('payments').select('*, profiles!payments_freelancer_id_fkey(full_name)')
    .eq('client_id', currentUser.id).order('created_at', { ascending: false })
    .then(function(res) {
      var el = document.getElementById('payments-table');
      if (!res.data || res.data.length === 0) {
        el.innerHTML = '<div class="empty"><div class="empty-icon">◆</div><h3>No payments yet</h3><p>Payments you make will appear here.</p></div>';
        return;
      }
      var html = '';
      for (var i = 0; i < res.data.length; i++) {
        var p = res.data[i];
        var name = p.profiles ? p.profiles.full_name : 'Unknown';
        var total = ((p.amount || 0) + (p.platform_fee || 0)).toFixed(2);
        var statusClass = p.status === 'released' ? 'badge-completed' : p.status === 'escrowed' ? 'badge-escrowed' : 'badge-open';
        html += '<div class="payment-row">';
        html += '<span style="font-family:\'Syne\',sans-serif;font-weight:700;font-size:0.85rem">' + esc(name) + '</span>';
        html += '<span style="font-family:\'Syne\',sans-serif;font-weight:700;color:var(--green)">$' + total + '</span>';
        html += '<span style="font-family:\'IBM Plex Mono\',monospace;font-size:0.72rem;color:var(--muted)">$' + (p.platform_fee || 0).toFixed(2) + '</span>';
        html += '<span><span class="badge ' + statusClass + '">' + p.status.toUpperCase() + '</span></span>';
        if (p.status === 'escrowed' || p.status === 'pending') {
          html += '<span><button class="release-btn" onclick="confirmRelease(\'' + p.id + '\',$' + total + ')">Release →</button></span>';
        } else {
          html += '<span style="font-family:\'IBM Plex Mono\',monospace;font-size:0.68rem;color:var(--muted2)">—</span>';
        }
        html += '</div>';
      }
      el.innerHTML = html;
    });
}

// ============================================================
// RELEASE PAYMENT
// ============================================================
function confirmRelease(paymentId, amount) {
  pendingReleaseId = paymentId;
  document.getElementById('modal-content').innerHTML =
    '<h3>Release Payment?</h3>' +
    '<p>This will release <strong style="color:var(--green)">' + amount + '</strong> from escrow to the freelancer. Only do this when you are satisfied with the work delivered. This cannot be undone.</p>' +
    '<div class="modal-actions">' +
    '<button class="modal-confirm" onclick="doRelease()">Yes, Release Payment</button>' +
    '<button class="modal-cancel" onclick="closeModal()">Cancel</button>' +
    '</div>';
  document.getElementById('modal-overlay').classList.add('open');
}

function doRelease() {
  if (!pendingReleaseId) return;
  var btn = document.querySelector('.modal-confirm');
  btn.textContent = 'Releasing...'; btn.disabled = true;

  supabase.auth.getSession().then(function(res) {
    var token = res.data.session.access_token;
    fetch(SUPABASE_URL + '/functions/v1/release-payment', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', 'Authorization': 'Bearer ' + token },
      body: JSON.stringify({ payment_id: pendingReleaseId })
    })
    .then(function(r) { return r.json(); })
    .then(function(data) {
      closeModal();
      if (data.error) showToast('Error: ' + data.error, 'error');
      else { showToast('Payment released! Freelancer has been paid.', 'success'); loadPaymentsView(); loadStats(); }
      pendingReleaseId = null;
    })
    .catch(function() {
      closeModal();
      showToast('Network error. Try again.', 'error');
      pendingReleaseId = null;
    });
  });
}

// ============================================================
// UTILS
// ============================================================
function esc(str) {
  if (!str) return '';
  return String(str).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
}

function showToast(msg, type) {
  var t = document.getElementById('toast');
  t.textContent = msg; t.className = 'toast ' + (type || '');
  t.classList.add('show');
  setTimeout(function() { t.classList.remove('show'); }, 3500);
}

function closeModal() {
  document.getElementById('modal-overlay').classList.remove('open');
}

document.getElementById('modal-overlay').addEventListener('click', function(e) {
  if (e.target === this) closeModal();
});
</script>

</body>
</html>
<!DOCTYPE html>

<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>SkillSwap — Freelancer Dashboard</title>
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=IBM+Plex+Mono:wght@400;500&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>
<style>
  :root {
    --bg: #0b0f0d;
    --surface: #111713;
    --surface2: #161c18;
    --border: #1e2820;
    --border2: #263030;
    --text: #e8f0eb;
    --muted: #4a5e50;
    --muted2: #2a3a2e;
    --accent: #22c55e;
    --accent-dim: rgba(34,197,94,0.1);
    --accent2: #e8440a;
    --accent2-dim: rgba(232,68,10,0.1);
    --yellow: #f59e0b;
    --yellow-dim: rgba(245,158,11,0.1);
    --blue: #3b82f6;
    --blue-dim: rgba(59,130,246,0.1);
    --red: #ef4444;
    --red-dim: rgba(239,68,68,0.1);
    --purple: #a855f7;
    --purple-dim: rgba(168,85,247,0.1);
  }
  * { margin:0; padding:0; box-sizing:border-box; }
  body { font-family:'DM Sans',sans-serif; background:var(--bg); color:var(--text); min-height:100vh; }

.layout { display:flex; min-height:100vh; }

/* SIDEBAR */
.sidebar {
width:220px; flex-shrink:0;
background:var(–surface);
border-right:1px solid var(–border);
display:flex; flex-direction:column;
position:fixed; top:0; left:0; bottom:0; z-index:50;
}
.sidebar-logo { padding:24px 20px 20px; border-bottom:1px solid var(–border); }
.logo-text { font-family:‘Syne’,sans-serif; font-weight:800; font-size:1.25rem; color:var(–text); letter-spacing:-0.5px; }
.logo-text span { color:var(–accent); }
.logo-sub { font-family:‘IBM Plex Mono’,monospace; font-size:0.62rem; color:var(–muted); margin-top:2px; letter-spacing:1px; }
.sidebar-nav { padding:16px 0; flex:1; }
.nav-item {
display:flex; align-items:center; gap:10px;
padding:10px 20px; cursor:pointer;
font-family:‘Syne’,sans-serif; font-weight:600; font-size:0.8rem;
color:var(–muted); transition:all 0.15s; letter-spacing:0.3px;
border-left:2px solid transparent;
}
.nav-item:hover { color:var(–text); background:var(–surface2); }
.nav-item.active { color:var(–text); border-left-color:var(–accent); background:var(–surface2); }
.nav-icon { font-size:1rem; width:20px; text-align:center; }
.nav-badge {
margin-left:auto; background:var(–accent); color:#000;
font-family:‘IBM Plex Mono’,monospace; font-weight:500; font-size:0.62rem;
padding:2px 7px; border-radius:20px; min-width:20px; text-align:center;
}
.sidebar-footer { padding:16px 20px; border-top:1px solid var(–border); }
.user-chip { display:flex; align-items:center; gap:10px; }
.user-dot { width:32px; height:32px; border-radius:50%; background:var(–accent); display:flex; align-items:center; justify-content:center; font-family:‘Syne’,sans-serif; font-weight:800; font-size:0.75rem; color:#000; flex-shrink:0; }
.user-name { font-family:‘Syne’,sans-serif; font-weight:700; font-size:0.78rem; color:var(–text); }
.user-role { font-size:0.68rem; color:var(–muted); margin-top:1px; }
.sign-out-btn { margin-top:12px; width:100%; background:transparent; border:1px solid var(–border2); color:var(–muted); padding:8px; border-radius:6px; font-family:‘Syne’,sans-serif; font-weight:700; font-size:0.72rem; cursor:pointer; transition:all 0.15s; letter-spacing:0.5px; }
.sign-out-btn:hover { border-color:var(–accent); color:var(–accent); }

/* MAIN */
.main { margin-left:220px; flex:1; }
.topbar { display:flex; align-items:center; justify-content:space-between; padding:20px 32px; border-bottom:1px solid var(–border); background:var(–surface); position:sticky; top:0; z-index:40; }
.topbar-title { font-family:‘Syne’,sans-serif; font-weight:800; font-size:1.1rem; letter-spacing:-0.3px; }
.topbar-sub { font-family:‘IBM Plex Mono’,monospace; font-size:0.68rem; color:var(–muted); margin-top:2px; }
.browse-btn { background:var(–accent); color:#000; padding:10px 20px; border-radius:8px; border:none; font-family:‘Syne’,sans-serif; font-weight:700; font-size:0.8rem; cursor:pointer; transition:all 0.15s; }
.browse-btn:hover { background:#16a34a; }

/* VIEWS */
.view { display:none; padding:32px; }
.view.active { display:block; }

/* STAT CARDS */
.stats-row { display:grid; grid-template-columns:repeat(4,1fr); gap:16px; margin-bottom:32px; }
.stat-card { background:var(–surface); border:1px solid var(–border); border-radius:12px; padding:20px; position:relative; overflow:hidden; }
.stat-card::after { content:’’; position:absolute; top:0; left:0; right:0; height:2px; }
.stat-card.green::after { background:var(–accent); }
.stat-card.orange::after { background:var(–accent2); }
.stat-card.yellow::after { background:var(–yellow); }
.stat-card.purple::after { background:var(–purple); }
.stat-label { font-family:‘IBM Plex Mono’,monospace; font-size:0.65rem; color:var(–muted); letter-spacing:1px; text-transform:uppercase; margin-bottom:10px; }
.stat-value { font-family:‘Syne’,sans-serif; font-weight:800; font-size:1.8rem; color:var(–text); line-height:1; }
.stat-value.green { color:var(–accent); }
.stat-value.orange { color:var(–accent2); }
.stat-value.yellow { color:var(–yellow); }
.stat-value.purple { color:var(–purple); }
.stat-change { font-size:0.72rem; color:var(–muted); margin-top:6px; }

/* SECTION */
.section-title { font-family:‘Syne’,sans-serif; font-weight:800; font-size:0.85rem; letter-spacing:1px; text-transform:uppercase; color:var(–muted); margin-bottom:16px; }

/* TABLE */
.table-wrap { background:var(–surface); border:1px solid var(–border); border-radius:12px; overflow:hidden; margin-bottom:32px; }
.table-header { padding:12px 20px; background:var(–surface2); border-bottom:1px solid var(–border); font-family:‘IBM Plex Mono’,monospace; font-size:0.65rem; color:var(–muted); letter-spacing:1px; text-transform:uppercase; display:grid; }
.table-row { padding:16px 20px; border-bottom:1px solid var(–border); align-items:center; transition:background 0.15s; display:grid; }
.table-row:last-child { border-bottom:none; }
.table-row:hover { background:var(–surface2); }

/* BADGES */
.badge { display:inline-flex; align-items:center; gap:5px; padding:4px 10px; border-radius:20px; font-family:‘IBM Plex Mono’,monospace; font-size:0.65rem; font-weight:500; letter-spacing:0.5px; white-space:nowrap; }
.badge::before { content:’’; width:5px; height:5px; border-radius:50%; flex-shrink:0; }
.badge-open { background:var(–blue-dim); color:var(–blue); }
.badge-open::before { background:var(–blue); }
.badge-pending { background:var(–yellow-dim); color:var(–yellow); }
.badge-pending::before { background:var(–yellow); }
.badge-accepted { background:var(–accent-dim); color:var(–accent); }
.badge-accepted::before { background:var(–accent); }
.badge-rejected { background:var(–red-dim); color:var(–red); }
.badge-rejected::before { background:var(–red); }
.badge-escrowed { background:var(–purple-dim); color:var(–purple); }
.badge-escrowed::before { background:var(–purple); }
.badge-released { background:var(–accent-dim); color:var(–accent); }
.badge-released::before { background:var(–accent); }
.badge-completed { background:var(–accent-dim); color:var(–accent); }
.badge-completed::before { background:var(–accent); }
.badge-progress { background:var(–yellow-dim); color:var(–yellow); }
.badge-progress::before { background:var(–yellow); }

/* BID CARDS */
.bids-grid { display:grid; grid-template-columns:repeat(auto-fill,minmax(300px,1fr)); gap:16px; margin-bottom:32px; }
.bid-card { background:var(–surface); border:1px solid var(–border); border-radius:12px; padding:20px; transition:all 0.15s; }
.bid-card:hover { border-color:var(–border2); }
.bid-card-top { display:flex; justify-content:space-between; align-items:flex-start; margin-bottom:10px; }
.bid-job-title { font-family:‘Syne’,sans-serif; font-weight:700; font-size:0.95rem; line-height:1.3; }
.bid-amount { font-family:‘Syne’,sans-serif; font-weight:800; font-size:1.1rem; color:var(–accent); white-space:nowrap; margin-left:12px; }
.bid-category { font-family:‘IBM Plex Mono’,monospace; font-size:0.68rem; color:var(–muted); margin-bottom:10px; }
.bid-letter { font-size:0.82rem; color:rgba(232,240,235,0.55); line-height:1.6; margin-bottom:14px; font-style:italic; }
.bid-footer { display:flex; justify-content:space-between; align-items:center; }
.bid-date { font-family:‘IBM Plex Mono’,monospace; font-size:0.68rem; color:var(–muted); }

/* JOBS BROWSE */
.jobs-list { display:grid; gap:12px; margin-bottom:32px; }
.job-item { background:var(–surface); border:1px solid var(–border); border-radius:12px; padding:20px; display:grid; grid-template-columns:1fr auto; gap:16px; align-items:center; transition:all 0.15s; cursor:pointer; }
.job-item:hover { border-color:var(–accent); background:var(–surface2); }
.job-item-title { font-family:‘Syne’,sans-serif; font-weight:700; font-size:0.95rem; margin-bottom:4px; }
.job-item-meta { font-family:‘IBM Plex Mono’,monospace; font-size:0.68rem; color:var(–muted); }
.job-item-right { text-align:right; }
.job-item-budget { font-family:‘Syne’,sans-serif; font-weight:800; font-size:1.1rem; color:var(–accent); margin-bottom:6px; }
.bid-now-btn { background:var(–accent-dim); color:var(–accent); border:1px solid rgba(34,197,94,0.2); padding:8px 16px; border-radius:6px; font-family:‘Syne’,sans-serif; font-weight:700; font-size:0.75rem; cursor:pointer; transition:all 0.15s; white-space:nowrap; }
.bid-now-btn:hover { background:var(–accent); color:#000; }

/* EARNINGS CHART */
.earnings-card { background:var(–surface); border:1px solid var(–border); border-radius:12px; padding:24px; margin-bottom:32px; }
.earnings-header { display:flex; justify-content:space-between; align-items:center; margin-bottom:20px; }
.earnings-total { font-family:‘Syne’,sans-serif; font-weight:800; font-size:2rem; color:var(–accent); }
.earnings-label { font-family:‘IBM Plex Mono’,monospace; font-size:0.68rem; color:var(–muted); margin-top:2px; letter-spacing:1px; }
.bar-chart { display:flex; gap:8px; align-items:flex-end; height:80px; }
.bar-wrap { flex:1; display:flex; flex-direction:column; align-items:center; gap:6px; }
.bar { width:100%; border-radius:4px 4px 0 0; background:var(–accent-dim); border:1px solid rgba(34,197,94,0.15); transition:all 0.3s; min-height:4px; }
.bar.has-value { background:var(–accent); border-color:var(–accent); }
.bar-label { font-family:‘IBM Plex Mono’,monospace; font-size:0.6rem; color:var(–muted); }

/* PROFILE EDIT */
.profile-card { background:var(–surface); border:1px solid var(–border); border-radius:12px; padding:28px; margin-bottom:20px; }
.profile-top { display:flex; align-items:center; gap:16px; margin-bottom:24px; padding-bottom:24px; border-bottom:1px solid var(–border); }
.profile-avatar-lg { width:72px; height:72px; border-radius:50%; background:var(–accent); display:flex; align-items:center; justify-content:center; font-family:‘Syne’,sans-serif; font-weight:800; font-size:1.5rem; color:#000; flex-shrink:0; }
.profile-meta h2 { font-family:‘Syne’,sans-serif; font-weight:800; font-size:1.2rem; }
.profile-meta p { font-size:0.82rem; color:var(–muted); margin-top:3px; }
.field { margin-bottom:18px; }
.field label { display:block; font-family:‘IBM Plex Mono’,monospace; font-size:0.68rem; color:var(–muted); letter-spacing:1px; text-transform:uppercase; margin-bottom:8px; }
.field input, .field textarea, .field select { width:100%; padding:11px 14px; background:var(–surface2); border:1px solid var(–border2); border-radius:8px; color:var(–text); font-family:‘DM Sans’,sans-serif; font-size:0.92rem; outline:none; transition:border-color 0.15s; }
.field input:focus, .field textarea:focus { border-color:var(–accent); }
.field textarea { min-height:90px; resize:vertical; }
.field-grid { display:grid; grid-template-columns:1fr 1fr; gap:14px; }
.save-btn { background:var(–accent); color:#000; padding:12px 28px; border-radius:8px; border:none; font-family:‘Syne’,sans-serif; font-weight:800; font-size:0.88rem; cursor:pointer; transition:all 0.15s; }
.save-btn:hover { background:#16a34a; }

/* EMPTY */
.empty { padding:50px 20px; text-align:center; }
.empty-icon { font-size:2.5rem; margin-bottom:12px; opacity:0.25; }
.empty h3 { font-family:‘Syne’,sans-serif; font-weight:800; font-size:1rem; color:var(–muted); margin-bottom:6px; }
.empty p { font-size:0.82rem; color:var(–muted2); }

/* LOADING */
.loading { padding:40px; text-align:center; font-family:‘IBM Plex Mono’,monospace; font-size:0.72rem; color:var(–muted); letter-spacing:2px; text-transform:uppercase; }
@keyframes pulse { 0%,100%{opacity:1} 50%{opacity:0.3} }
.loading { animation:pulse 1.5s infinite; }

/* LOGIN */
.login-screen { display:flex; align-items:center; justify-content:center; min-height:100vh; background:var(–bg); padding:20px; }
.login-box { background:var(–surface); border:1px solid var(–border); border-radius:16px; padding:40px; width:100%; max-width:400px; }
.login-logo { font-family:‘Syne’,sans-serif; font-weight:800; font-size:1.6rem; margin-bottom:4px; }
.login-logo span { color:var(–accent); }
.login-sub { font-family:‘IBM Plex Mono’,monospace; font-size:0.7rem; color:var(–muted); margin-bottom:32px; letter-spacing:1px; }
.login-btn { width:100%; padding:14px; background:var(–accent); color:#000; border:none; border-radius:8px; font-family:‘Syne’,sans-serif; font-weight:800; font-size:0.9rem; cursor:pointer; transition:all 0.15s; margin-top:8px; }
.login-btn:hover { background:#16a34a; }
.login-btn:disabled { background:var(–muted2); cursor:not-allowed; }
.login-err { font-size:0.8rem; color:var(–accent2); margin-top:10px; text-align:center; min-height:20px; }

/* MODAL */
.modal-overlay { display:none; position:fixed; inset:0; background:rgba(0,0,0,0.75); z-index:200; align-items:center; justify-content:center; padding:20px; }
.modal-overlay.open { display:flex; }
.modal { background:var(–surface); border:1px solid var(–border2); border-radius:16px; padding:32px; max-width:460px; width:100%; position:relative; max-height:90vh; overflow-y:auto; }
.modal-close { position:absolute; top:14px; right:16px; background:none; border:none; color:var(–muted); font-size:1.3rem; cursor:pointer; }
.modal h3 { font-family:‘Syne’,sans-serif; font-weight:800; font-size:1.1rem; margin-bottom:4px; }
.modal-sub { font-size:0.82rem; color:var(–muted); margin-bottom:20px; }
.modal-budget { font-family:‘Syne’,sans-serif; font-weight:800; font-size:1.5rem; color:var(–accent); margin-bottom:16px; }
.modal-submit { width:100%; padding:13px; background:var(–accent); color:#000; border:none; border-radius:8px; font-family:‘Syne’,sans-serif; font-weight:800; font-size:0.9rem; cursor:pointer; transition:all 0.15s; }
.modal-submit:hover { background:#16a34a; }
.modal-submit:disabled { background:var(–muted2); cursor:not-allowed; }

/* TOAST */
.toast { position:fixed; bottom:24px; right:24px; background:var(–surface); border:1px solid var(–border2); color:var(–text); padding:14px 18px; border-radius:10px; font-family:‘IBM Plex Mono’,monospace; font-size:0.75rem; z-index:999; transform:translateY(80px); opacity:0; transition:all 0.3s; max-width:300px; letter-spacing:0.3px; }
.toast.show { transform:translateY(0); opacity:1; }
.toast.success { border-left:3px solid var(–accent); }
.toast.error { border-left:3px solid var(–accent2); }

@media(max-width:768px){
.sidebar { display:none; }
.main { margin-left:0; }
.stats-row { grid-template-columns:1fr 1fr; }
.view { padding:20px; }
.field-grid { grid-template-columns:1fr; }
}
</style>

</head>
<body>

<!-- LOGIN -->

<div id="login-screen" class="login-screen">
  <div class="login-box">
    <div class="login-logo">Skill<span>Swap</span></div>
    <div class="login-sub">FREELANCER DASHBOARD</div>
    <div class="field"><label>Email</label><input type="email" id="login-email" placeholder="you@email.com"></div>
    <div class="field"><label>Password</label><input type="password" id="login-pass" placeholder="••••••••" onkeydown="if(event.key==='Enter')doLogin()"></div>
    <button class="login-btn" id="login-btn" onclick="doLogin()">Access Dashboard →</button>
    <div class="login-err" id="login-err"></div>
  </div>
</div>

<!-- DASHBOARD -->

<div id="dashboard" style="display:none">
  <div class="layout">
    <aside class="sidebar">
      <div class="sidebar-logo">
        <div class="logo-text">Skill<span>Swap</span></div>
        <div class="logo-sub">FREELANCER DASHBOARD</div>
      </div>
      <nav class="sidebar-nav">
        <div class="nav-item active" onclick="showView('overview')"><span class="nav-icon">◈</span>Overview</div>
        <div class="nav-item" onclick="showView('browse')"><span class="nav-icon">◻</span>Browse Jobs</div>
        <div class="nav-item" onclick="showView('bids')"><span class="nav-icon">◎</span>My Bids <span class="nav-badge" id="bid-badge" style="display:none">0</span></div>
        <div class="nav-item" onclick="showView('earnings')"><span class="nav-icon">◆</span>Earnings</div>
        <div class="nav-item" onclick="showView('profile')"><span class="nav-icon">◉</span>My Profile</div>
      </nav>
      <div class="sidebar-footer">
        <div class="user-chip">
          <div class="user-dot" id="user-dot">?</div>
          <div>
            <div class="user-name" id="user-name-display">Loading...</div>
            <div class="user-role">Freelancer</div>
          </div>
        </div>
        <button class="sign-out-btn" onclick="signOut()">SIGN OUT</button>
      </div>
    </aside>

```
<main class="main">
  <div class="topbar">
    <div>
      <div class="topbar-title" id="topbar-title">Overview</div>
      <div class="topbar-sub" id="topbar-sub">Your freelance command center</div>
    </div>
    <button class="browse-btn" onclick="showView('browse')">Browse Jobs →</button>
  </div>

  <!-- OVERVIEW -->
  <div id="view-overview" class="view active">
    <div class="stats-row">
      <div class="stat-card green">
        <div class="stat-label">Total Earned</div>
        <div class="stat-value green" id="stat-earned">$0</div>
        <div class="stat-change">released payments</div>
      </div>
      <div class="stat-card purple">
        <div class="stat-label">In Escrow</div>
        <div class="stat-value purple" id="stat-escrow">$0</div>
        <div class="stat-change">awaiting release</div>
      </div>
      <div class="stat-card yellow">
        <div class="stat-label">Active Bids</div>
        <div class="stat-value yellow" id="stat-active-bids">0</div>
        <div class="stat-change">pending review</div>
      </div>
      <div class="stat-card orange">
        <div class="stat-label">Jobs Won</div>
        <div class="stat-value orange" id="stat-won">0</div>
        <div class="stat-change">accepted bids</div>
      </div>
    </div>

    <div class="section-title">My Recent Bids</div>
    <div class="table-wrap">
      <div class="table-header" style="grid-template-columns:2fr 1fr 1fr 1fr">
        <span>Job</span><span>My Bid</span><span>Status</span><span>Date</span>
      </div>
      <div id="overview-bids-table"><div class="loading">Loading...</div></div>
    </div>

    <div class="section-title">Incoming Payments</div>
    <div class="table-wrap">
      <div class="table-header" style="grid-template-columns:2fr 1fr 1fr 1fr">
        <span>Client</span><span>Amount</span><span>My Cut</span><span>Status</span>
      </div>
      <div id="overview-payments-table"><div class="loading">Loading...</div></div>
    </div>
  </div>

  <!-- BROWSE JOBS -->
  <div id="view-browse" class="view">
    <div id="browse-filter" style="display:flex;gap:10px;flex-wrap:wrap;margin-bottom:20px">
      <select id="cat-filter" onchange="loadBrowse()" style="background:var(--surface);border:1px solid var(--border2);color:var(--text);padding:9px 14px;border-radius:8px;font-family:'IBM Plex Mono',monospace;font-size:0.72rem;outline:none;cursor:pointer">
        <option value="">All Categories</option>
        <option>Web & App Development</option>
        <option>Design & Creative</option>
        <option>Marketing & SEO</option>
        <option>Writing & Content</option>
        <option>Video & Animation</option>
        <option>Business & Finance</option>
        <option>Admin & Virtual Assistant</option>
      </select>
    </div>
    <div id="browse-jobs"><div class="loading">Loading jobs...</div></div>
  </div>

  <!-- MY BIDS -->
  <div id="view-bids" class="view">
    <div id="bids-container"><div class="loading">Loading...</div></div>
  </div>

  <!-- EARNINGS -->
  <div id="view-earnings" class="view">
    <div class="earnings-card">
      <div class="earnings-header">
        <div>
          <div class="earnings-total" id="earnings-total">$0</div>
          <div class="earnings-label">TOTAL EARNED (AFTER PLATFORM FEE)</div>
        </div>
        <div style="text-align:right">
          <div style="font-family:'Syne',sans-serif;font-weight:800;font-size:1.1rem;color:var(--purple)" id="escrow-total">$0</div>
          <div class="earnings-label">IN ESCROW</div>
        </div>
      </div>
      <div class="bar-chart" id="earnings-chart"></div>
      <div style="display:flex;justify-content:space-between;margin-top:6px">
        <span id="bar-labels"></span>
      </div>
    </div>

    <div class="section-title">Payment History</div>
    <div class="table-wrap">
      <div class="table-header" style="grid-template-columns:2fr 1fr 1fr 1fr 1fr">
        <span>Job / Client</span><span>Gross</span><span>Fee (10%)</span><span>You Receive</span><span>Status</span>
      </div>
      <div id="earnings-table"><div class="loading">Loading...</div></div>
    </div>
  </div>

  <!-- PROFILE -->
  <div id="view-profile" class="view">
    <div class="profile-card">
      <div class="profile-top">
        <div class="profile-avatar-lg" id="profile-avatar-lg">?</div>
        <div class="profile-meta">
          <h2 id="profile-display-name">Your Name</h2>
          <p id="profile-display-email"></p>
        </div>
      </div>
      <div class="field-grid">
        <div class="field"><label>Full Name</label><input type="text" id="p-name" placeholder="Your full name"></div>
        <div class="field"><label>Hourly Rate ($)</label><input type="number" id="p-rate" placeholder="75"></div>
      </div>
      <div class="field-grid">
        <div class="field"><label>Location</label><input type="text" id="p-location" placeholder="New York, USA"></div>
        <div class="field"><label>Skills (comma separated)</label><input type="text" id="p-skills" placeholder="React, Figma, SEO"></div>
      </div>
      <div class="field"><label>Bio / Pitch</label><textarea id="p-bio" placeholder="Tell clients why you're the best hire..."></textarea></div>
      <button class="save-btn" onclick="saveProfile()">Save Profile →</button>
    </div>
  </div>

</main>
```

  </div>
</div>

<!-- BID MODAL -->

<div class="modal-overlay" id="modal-overlay">
  <div class="modal">
    <button class="modal-close" onclick="closeModal()">×</button>
    <div id="modal-content"></div>
  </div>
</div>

<div class="toast" id="toast"></div>

<script>
var SUPABASE_URL = 'https://cowwlpiatpyiadrllkzr.supabase.co';
var SUPABASE_ANON_KEY = 'YOUR_SUPABASE_ANON_KEY'; // paste your key here

var supabase = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
var currentUser = null;
var currentProfile = null;

// ============================================================
// INIT
// ============================================================
supabase.auth.getSession().then(function(res) {
  if (res.data && res.data.session) {
    currentUser = res.data.session.user;
    bootDashboard();
  }
});

supabase.auth.onAuthStateChange(function(event, session) {
  if (session && !currentUser) {
    currentUser = session.user;
    bootDashboard();
  } else if (!session) {
    currentUser = null; currentProfile = null;
    document.getElementById('dashboard').style.display = 'none';
    document.getElementById('login-screen').style.display = 'flex';
  }
});

// ============================================================
// AUTH
// ============================================================
function doLogin() {
  var email = document.getElementById('login-email').value;
  var pass = document.getElementById('login-pass').value;
  var err = document.getElementById('login-err');
  var btn = document.getElementById('login-btn');
  if (!email || !pass) { err.textContent = 'Please enter your email and password.'; return; }
  btn.disabled = true; btn.textContent = 'Signing in...';
  supabase.auth.signInWithPassword({ email: email, password: pass })
    .then(function(res) {
      if (res.error) { err.textContent = res.error.message; btn.disabled = false; btn.textContent = 'Access Dashboard →'; }
    });
}

function signOut() {
  supabase.auth.signOut();
}

// ============================================================
// BOOT
// ============================================================
function bootDashboard() {
  document.getElementById('login-screen').style.display = 'none';
  document.getElementById('dashboard').style.display = 'block';
  loadProfile();
  loadOverview();
}

function loadProfile() {
  supabase.from('profiles').select('*').eq('id', currentUser.id).single()
    .then(function(res) {
      if (!res.data) return;
      currentProfile = res.data;
      var name = res.data.full_name || currentUser.email;
      var initials = name.split(' ').map(function(n) { return n[0]; }).join('').substring(0,2).toUpperCase();
      document.getElementById('user-dot').textContent = initials;
      document.getElementById('user-name-display').textContent = name.split(' ')[0];
      document.getElementById('topbar-sub').textContent = 'Welcome back, ' + name.split(' ')[0];
      // Profile form
      document.getElementById('p-name').value = res.data.full_name || '';
      document.getElementById('p-rate').value = res.data.hourly_rate || '';
      document.getElementById('p-location').value = res.data.location || '';
      document.getElementById('p-skills').value = res.data.skills ? res.data.skills.join(', ') : '';
      document.getElementById('p-bio').value = res.data.bio || '';
      document.getElementById('profile-avatar-lg').textContent = initials;
      document.getElementById('profile-display-name').textContent = name;
      document.getElementById('profile-display-email').textContent = currentUser.email;
    });
}

// ============================================================
// OVERVIEW
// ============================================================
function loadOverview() {
  loadStats();
  loadOverviewBids();
  loadOverviewPayments();
}

function loadStats() {
  // Bids
  supabase.from('bids').select('id, status', { count:'exact' }).eq('freelancer_id', currentUser.id)
    .then(function(res) {
      if (!res.data) return;
      var pending = 0; var won = 0;
      for (var i = 0; i < res.data.length; i++) {
        if (res.data[i].status === 'pending') pending++;
        if (res.data[i].status === 'accepted') won++;
      }
      document.getElementById('stat-active-bids').textContent = pending;
      document.getElementById('stat-won').textContent = won;
      if (pending > 0) {
        var badge = document.getElementById('bid-badge');
        badge.textContent = pending; badge.style.display = 'inline-block';
      }
    });

  // Payments
  supabase.from('payments').select('amount, platform_fee, status').eq('freelancer_id', currentUser.id)
    .then(function(res) {
      if (!res.data) return;
      var earned = 0; var escrow = 0;
      for (var i = 0; i < res.data.length; i++) {
        var p = res.data[i];
        var myShare = (p.amount || 0); // amount minus platform fee already accounted
        if (p.status === 'released') earned += myShare;
        if (p.status === 'escrowed' || p.status === 'pending') escrow += myShare;
      }
      document.getElementById('stat-earned').textContent = '$' + earned.toFixed(0);
      document.getElementById('stat-escrow').textContent = '$' + escrow.toFixed(0);
    });
}

function loadOverviewBids() {
  supabase.from('bids').select('*, jobs(title, budget, category)').eq('freelancer_id', currentUser.id)
    .order('created_at', { ascending: false }).limit(5)
    .then(function(res) {
      var el = document.getElementById('overview-bids-table');
      if (!res.data || res.data.length === 0) {
        el.innerHTML = '<div class="empty"><div class="empty-icon">◎</div><h3>No bids yet</h3><p>Browse jobs and place your first bid.</p></div>';
        return;
      }
      var html = '';
      for (var i = 0; i < res.data.length; i++) {
        var b = res.data[i];
        var job = b.jobs || {};
        var date = new Date(b.created_at).toLocaleDateString('en-US', { month:'short', day:'numeric' });
        var statusClass = 'badge-' + b.status;
        html += '<div class="table-row" style="grid-template-columns:2fr 1fr 1fr 1fr">';
        html += '<span style="font-family:\'Syne\',sans-serif;font-weight:700;font-size:0.85rem">' + esc(job.title || 'Unknown') + '</span>';
        html += '<span style="font-family:\'Syne\',sans-serif;font-weight:700;color:var(--accent)">$' + b.amount + '</span>';
        html += '<span><span class="badge ' + statusClass + '">' + b.status.toUpperCase() + '</span></span>';
        html += '<span style="font-family:\'IBM Plex Mono\',monospace;font-size:0.7rem;color:var(--muted)">' + date + '</span>';
        html += '</div>';
      }
      el.innerHTML = html;
    });
}

function loadOverviewPayments() {
  supabase.from('payments').select('*, profiles!payments_client_id_fkey(full_name)')
    .eq('freelancer_id', currentUser.id).order('created_at', { ascending: false }).limit(5)
    .then(function(res) {
      var el = document.getElementById('overview-payments-table');
      if (!res.data || res.data.length === 0) {
        el.innerHTML = '<div class="empty"><div class="empty-icon">◆</div><h3>No payments yet</h3><p>Payments from clients will appear here.</p></div>';
        return;
      }
      var html = '';
      for (var i = 0; i < res.data.length; i++) {
        var p = res.data[i];
        var clientName = p.profiles ? p.profiles.full_name : 'Client';
        var myShare = (p.amount || 0);
        var statusClass = 'badge-' + p.status;
        html += '<div class="table-row" style="grid-template-columns:2fr 1fr 1fr 1fr">';
        html += '<span style="font-family:\'Syne\',sans-serif;font-weight:700;font-size:0.85rem">' + esc(clientName) + '</span>';
        html += '<span style="font-family:\'Syne\',sans-serif;font-weight:700;color:var(--accent)">$' + myShare.toFixed(2) + '</span>';
        html += '<span style="font-family:\'Syne\',sans-serif;font-weight:700;color:var(--accent)">$' + myShare.toFixed(2) + '</span>';
        html += '<span><span class="badge ' + statusClass + '">' + p.status.toUpperCase() + '</span></span>';
        html += '</div>';
      }
      el.innerHTML = html;
    });
}

// ============================================================
// BROWSE JOBS
// ============================================================
function loadBrowse() {
  var cat = document.getElementById('cat-filter').value;
  var query = supabase.from('jobs').select('*').eq('status', 'open').order('created_at', { ascending: false });
  if (cat) query = query.eq('category', cat);
  query.then(function(res) {
    var el = document.getElementById('browse-jobs');
    if (!res.data || res.data.length === 0) {
      el.innerHTML = '<div class="empty"><div class="empty-icon">◻</div><h3>No open jobs</h3><p>Check back soon — new jobs are posted daily.</p></div>';
      return;
    }
    var html = '<div class="jobs-list">';
    for (var i = 0; i < res.data.length; i++) {
      var j = res.data[i];
      var deadline = j.deadline ? new Date(j.deadline).toLocaleDateString('en-US', { month:'short', day:'numeric' }) : 'Open';
      html += '<div class="job-item" onclick="openBidModal(\'' + j.id + '\',\'' + esc(j.title) + '\',' + (j.budget||0) + ',\'' + esc(j.category||'') + '\')">';
      html += '<div>';
      html += '<div class="job-item-title">' + esc(j.title) + (j.urgent ? ' <span style="font-size:0.65rem;color:var(--accent2);font-family:\'IBM Plex Mono\',monospace"> URGENT</span>' : '') + '</div>';
      html += '<div class="job-item-meta">' + esc(j.category || 'General') + ' · Deadline: ' + deadline + '</div>';
      if (j.description) html += '<div style="font-size:0.82rem;color:rgba(232,240,235,0.5);margin-top:6px;line-height:1.5">' + esc(j.description.substring(0,100)) + '...</div>';
      html += '</div>';
      html += '<div class="job-item-right">';
      html += '<div class="job-item-budget">$' + (j.budget || '?') + '</div>';
      html += '<button class="bid-now-btn">Bid Now →</button>';
      html += '</div>';
      html += '</div>';
    }
    html += '</div>';
    el.innerHTML = html;
  });
}

// ============================================================
// BID MODAL
// ============================================================
function openBidModal(jobId, title, budget, category) {
  var html = '<h3>' + title + '</h3>';
  html += '<p class="modal-sub">' + category + '</p>';
  html += '<div class="modal-budget">Budget: $' + budget + '</div>';
  html += '<div class="field"><label>Your Bid ($)</label><input type="number" id="bid-amount" placeholder="' + budget + '"></div>';
  html += '<div class="field"><label>Cover Letter</label><textarea id="bid-letter" placeholder="Tell the client why you\'re perfect for this..."></textarea></div>';

html += ‘<button class="modal-submit" id="bid-submit-btn" onclick="submitBid(\'' + jobId + '\')">Submit Bid →</button>’;
document.getElementById(‘modal-content’).innerHTML = html;
document.getElementById(‘modal-overlay’).classList.add(‘open’);
}

function submitBid(jobId) {
var amount = parseFloat(document.getElementById(‘bid-amount’).value);
var letter = document.getElementById(‘bid-letter’).value;
if (!amount) { showToast(‘Enter your bid amount.’, ‘error’); return; }
var btn = document.getElementById(‘bid-submit-btn’);
btn.disabled = true; btn.textContent = ‘Submitting…’;
supabase.from(‘bids’).insert([{
job_id: jobId,
freelancer_id: currentUser.id,
amount: amount,
cover_letter: letter,
status: ‘pending’
}]).then(function(res) {
if (res.error) {
var msg = res.error.message.indexOf(‘unique’) > -1 ? ‘You already bid on this job.’ : res.error.message;
showToast(’Error: ’ + msg, ‘error’);
btn.disabled = false; btn.textContent = ‘Submit Bid →’;
} else {
showToast(‘Bid submitted! Good luck 🎯’, ‘success’);
closeModal(); loadStats();
}
});
}

// ============================================================
// MY BIDS VIEW
// ============================================================
function loadBidsView() {
supabase.from(‘bids’).select(’*, jobs(title, budget, category, status)’)
.eq(‘freelancer_id’, currentUser.id).order(‘created_at’, { ascending: false })
.then(function(res) {
var el = document.getElementById(‘bids-container’);
if (!res.data || res.data.length === 0) {
el.innerHTML = ‘<div class="empty"><div class="empty-icon">◎</div><h3>No bids placed yet</h3><p>Browse open jobs and start bidding to win work.</p></div>’;
return;
}
var html = ‘<div class="bids-grid">’;
for (var i = 0; i < res.data.length; i++) {
var b = res.data[i];
var job = b.jobs || {};
var date = new Date(b.created_at).toLocaleDateString(‘en-US’, { month:‘short’, day:‘numeric’ });
var statusClass = ‘badge-’ + b.status;
html += ‘<div class="bid-card">’;
html += ‘<div class="bid-card-top">’;
html += ‘<div><div class="bid-job-title">’ + esc(job.title || ‘Unknown Job’) + ‘</div></div>’;
html += ‘<div class="bid-amount">$’ + b.amount + ‘</div>’;
html += ‘</div>’;
html += ‘<div class="bid-category">’ + esc(job.category || ‘General’) + ’ · Budget: $’ + (job.budget || ‘?’) + ‘</div>’;
if (b.cover_letter) html += ‘<div class="bid-letter">”’ + esc(b.cover_letter.substring(0, 140)) + (b.cover_letter.length > 140 ? ‘…’ : ‘’) + ‘”</div>’;
html += ‘<div class="bid-footer">’;
html += ‘<span class="badge ' + statusClass + '">’ + b.status.toUpperCase() + ‘</span>’;
html += ‘<span class="bid-date">’ + date + ‘</span>’;
html += ‘</div>’;
html += ‘</div>’;
}
html += ‘</div>’;
el.innerHTML = html;
});
}

// ============================================================
// EARNINGS VIEW
// ============================================================
function loadEarningsView() {
supabase.from(‘payments’).select(’*, profiles!payments_client_id_fkey(full_name)’)
.eq(‘freelancer_id’, currentUser.id).order(‘created_at’, { ascending: false })
.then(function(res) {
var data = res.data || [];
var totalEarned = 0; var totalEscrow = 0;
var monthlyData = {};

```
  for (var i = 0; i < data.length; i++) {
    var p = data[i];
    var myShare = p.amount || 0;
    var month = new Date(p.created_at).toLocaleDateString('en-US', { month:'short' });
    if (!monthlyData[month]) monthlyData[month] = 0;
    if (p.status === 'released') { totalEarned += myShare; monthlyData[month] += myShare; }
    if (p.status === 'escrowed' || p.status === 'pending') totalEscrow += myShare;
  }

  document.getElementById('earnings-total').textContent = '$' + totalEarned.toFixed(0);
  document.getElementById('escrow-total').textContent = '$' + totalEscrow.toFixed(0);

  // Simple bar chart
  var months = Object.keys(monthlyData);
  var maxVal = 0;
  for (var m = 0; m < months.length; m++) if (monthlyData[months[m]] > maxVal) maxVal = monthlyData[months[m]];
  var chartHtml = '';
  var labelsHtml = '<div style="display:flex;gap:8px;width:100%">';
  for (var m = 0; m < months.length; m++) {
    var pct = maxVal > 0 ? (monthlyData[months[m]] / maxVal * 100) : 0;
    chartHtml += '<div class="bar-wrap">';
    chartHtml += '<div class="bar ' + (pct > 0 ? 'has-value' : '') + '" style="height:' + Math.max(pct, 5) + '%"></div>';
    chartHtml += '<div class="bar-label">' + months[m] + '</div>';
    chartHtml += '</div>';
  }
  if (months.length === 0) {
    chartHtml = '<div style="font-family:\'IBM Plex Mono\',monospace;font-size:0.72rem;color:var(--muted);padding:20px 0">No earnings data yet</div>';
  }
  document.getElementById('earnings-chart').innerHTML = chartHtml;

  // Table
  var el = document.getElementById('earnings-table');
  if (data.length === 0) {
    el.innerHTML = '<div class="empty"><div class="empty-icon">◆</div><h3>No payments yet</h3><p>Win bids and complete jobs to start earning.</p></div>';
    return;
  }
  var tableHtml = '';
  for (var i = 0; i < data.length; i++) {
    var p = data[i];
    var clientName = p.profiles ? p.profiles.full_name : 'Client';
    var gross = (p.amount || 0) + (p.platform_fee || 0);
    var fee = p.platform_fee || 0;
    var myShare = p.amount || 0;
    var statusClass = 'badge-' + p.status;
    tableHtml += '<div class="table-row" style="grid-template-columns:2fr 1fr 1fr 1fr 1fr">';
    tableHtml += '<span style="font-family:\'Syne\',sans-serif;font-weight:700;font-size:0.85rem">' + esc(clientName) + '</span>';
    tableHtml += '<span style="font-family:\'Syne\',sans-serif;font-weight:700;color:rgba(232,240,235,0.5)">$' + gross.toFixed(2) + '</span>';
    tableHtml += '<span style="font-family:\'IBM Plex Mono\',monospace;font-size:0.72rem;color:var(--accent2)">-$' + fee.toFixed(2) + '</span>';
    tableHtml += '<span style="font-family:\'Syne\',sans-serif;font-weight:800;color:var(--accent)">$' + myShare.toFixed(2) + '</span>';
    tableHtml += '<span><span class="badge ' + statusClass + '">' + p.status.toUpperCase() + '</span></span>';
    tableHtml += '</div>';
  }
  el.innerHTML = tableHtml;
});
```

}

// ============================================================
// PROFILE SAVE
// ============================================================
function saveProfile() {
if (!currentUser) return;
var updates = {
full_name: document.getElementById(‘p-name’).value,
bio: document.getElementById(‘p-bio’).value,
hourly_rate: parseFloat(document.getElementById(‘p-rate’).value) || null,
location: document.getElementById(‘p-location’).value,
skills: document.getElementById(‘p-skills’).value.split(’,’).map(function(s) { return s.trim(); }).filter(Boolean),
role: ‘freelancer’
};
supabase.from(‘profiles’).update(updates).eq(‘id’, currentUser.id)
.then(function(res) {
if (res.error) showToast(‘Error saving profile.’, ‘error’);
else {
currentProfile = Object.assign({}, currentProfile, updates);
var name = updates.full_name || currentUser.email;
var initials = name.split(’ ‘).map(function(n) { return n[0]; }).join(’’).substring(0,2).toUpperCase();
document.getElementById(‘user-dot’).textContent = initials;
document.getElementById(‘user-name-display’).textContent = name.split(’ ’)[0];
document.getElementById(‘profile-avatar-lg’).textContent = initials;
document.getElementById(‘profile-display-name’).textContent = name;
showToast(‘Profile saved! You are now listed in Find Talent.’, ‘success’);
}
});
}

// ============================================================
// VIEWS
// ============================================================
var viewTitles = { overview:‘Overview’, browse:‘Browse Jobs’, bids:‘My Bids’, earnings:‘Earnings’, profile:‘My Profile’ };

function showView(name) {
var views = [‘overview’,‘browse’,‘bids’,‘earnings’,‘profile’];
var navItems = document.querySelectorAll(’.nav-item’);
for (var i = 0; i < views.length; i++) {
document.getElementById(‘view-’ + views[i]).classList.remove(‘active’);
navItems[i].classList.remove(‘active’);
}
document.getElementById(‘view-’ + name).classList.add(‘active’);
var idx = views.indexOf(name);
navItems[idx].classList.add(‘active’);
document.getElementById(‘topbar-title’).textContent = viewTitles[name];
if (name === ‘browse’) loadBrowse();
if (name === ‘bids’) loadBidsView();
if (name === ‘earnings’) loadEarningsView();
}

// ============================================================
// UTILS
// ============================================================
function esc(str) {
if (!str) return ‘’;
return String(str).replace(/&/g,’&’).replace(/</g,’<’).replace(/>/g,’>’).replace(/”/g,’"’);
}
function showToast(msg, type) {
var t = document.getElementById(‘toast’);
t.textContent = msg; t.className = ’toast ’ + (type || ‘’);
t.classList.add(‘show’);
setTimeout(function() { t.classList.remove(‘show’); }, 3500);
}
function closeModal() { document.getElementById(‘modal-overlay’).classList.remove(‘open’); }
document.getElementById(‘modal-overlay’).addEventListener(‘click’, function(e) { if (e.target === this) closeModal(); });
</script>

</body>
