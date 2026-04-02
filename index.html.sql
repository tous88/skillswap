<!DOCTYPE html>

<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>SkillSwap — Hire Fast. Earn Faster.</title>
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500&family=IBM+Plex+Mono:wght@400;500&display=swap" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>
<script src="https://js.stripe.com/v3/"></script>
<style>
:root {
  --ink:#0a0a0f; --paper:#f5f3ee; --cream:#ede9e0;
  --accent:#e8440a; --green:#22c55e; --gold:#c9a84c;
  --muted:#7a7671; --card:#ffffff; --border:#ddd9d0;
  --dk:#0d0d0d; --dksurface:#141414; --dksurface2:#1a1a1a;
  --dkborder:#262626; --dktext:#f0ede8; --dkmuted:#5a5a5a;
  --purple:#a855f7;
}
*{margin:0;padding:0;box-sizing:border-box;}
body{font-family:'DM Sans',sans-serif;min-height:100vh;}

/* ── PAGE SYSTEM ── */
.page{display:none;min-height:100vh;}
.page.active{display:block;}

/* ══════════════════════════════════
MAIN MARKETPLACE (LIGHT)
══════════════════════════════════ */
#page-main{background:var(–paper);color:var(–ink);}
.m-nav{display:flex;align-items:center;justify-content:space-between;padding:18px 40px;background:var(–ink);position:sticky;top:0;z-index:100;}
.m-logo{font-family:‘Syne’,sans-serif;font-weight:800;font-size:1.5rem;color:var(–paper);letter-spacing:-0.5px;}
.m-logo span{color:var(–accent);}
.m-navlinks{display:flex;gap:10px;align-items:center;}
.m-nbtn{font-family:‘DM Sans’,sans-serif;font-size:0.85rem;font-weight:500;padding:9px 18px;border-radius:6px;cursor:pointer;border:none;transition:all 0.2s;}
.m-ghost{background:transparent;color:var(–paper);border:1px solid rgba(255,255,255,0.2);}
.m-ghost:hover{border-color:var(–accent);color:var(–accent);}
.m-solid{background:var(–accent);color:#fff;}
.m-solid:hover{background:#c93a08;}
.m-navuser{font-family:‘Syne’,sans-serif;font-size:0.8rem;font-weight:700;color:rgba(255,255,255,0.6);}
.m-dashlink{font-family:‘Syne’,sans-serif;font-size:0.75rem;font-weight:700;color:var(–gold);cursor:pointer;padding:8px 14px;border:1px solid rgba(201,168,76,0.3);border-radius:6px;}
.m-dashlink:hover{background:rgba(201,168,76,0.1);}

.m-tabs{display:flex;background:var(–ink);padding:0 40px;border-top:1px solid rgba(255,255,255,0.08);overflow-x:auto;}
.m-tab{font-family:‘Syne’,sans-serif;font-size:0.8rem;font-weight:600;color:rgba(255,255,255,0.45);padding:12px 20px;cursor:pointer;border-bottom:2px solid transparent;transition:all 0.2s;letter-spacing:0.5px;text-transform:uppercase;white-space:nowrap;}
.m-tab.active{color:var(–paper);border-bottom-color:var(–accent);}

.m-view{display:none;}
.m-view.active{display:block;}

.m-hero{padding:70px 40px 50px;max-width:1100px;margin:0 auto;display:grid;grid-template-columns:1fr 1fr;gap:60px;align-items:center;}
.m-eyebrow{font-family:‘Syne’,sans-serif;font-size:0.75rem;font-weight:700;letter-spacing:2px;text-transform:uppercase;color:var(–accent);margin-bottom:14px;}
.m-h1{font-family:‘Syne’,sans-serif;font-size:3.2rem;font-weight:800;line-height:1.05;letter-spacing:-1.5px;color:var(–ink);margin-bottom:18px;}
.m-h1 em{font-style:normal;color:var(–accent);}
.m-hdesc{font-size:1rem;color:var(–muted);line-height:1.7;margin-bottom:28px;font-weight:300;}
.m-ctas{display:flex;gap:12px;flex-wrap:wrap;}
.m-btnp{background:var(–accent);color:#fff;padding:13px 26px;border-radius:8px;border:none;font-family:‘Syne’,sans-serif;font-weight:700;font-size:0.88rem;cursor:pointer;transition:all 0.2s;}
.m-btnp:hover{background:#c93a08;transform:translateY(-1px);}
.m-btns{background:transparent;color:var(–ink);padding:13px 26px;border-radius:8px;border:2px solid var(–border);font-family:‘Syne’,sans-serif;font-weight:700;font-size:0.88rem;cursor:pointer;transition:all 0.2s;}
.m-btns:hover{border-color:var(–ink);}

.m-statscard{background:var(–ink);border-radius:16px;padding:32px;display:grid;grid-template-columns:1fr 1fr;gap:20px;}
.m-statnum{font-family:‘Syne’,sans-serif;font-size:2rem;font-weight:800;color:var(–paper);line-height:1;}
.m-statnum span{color:var(–accent);}
.m-statlbl{font-size:0.75rem;color:rgba(255,255,255,0.4);margin-top:3px;letter-spacing:0.5px;text-transform:uppercase;}
.m-statdiv{grid-column:1/-1;height:1px;background:rgba(255,255,255,0.08);}

.m-section{padding:50px 40px;max-width:1100px;margin:0 auto;}
.m-sh{margin-bottom:30px;}
.m-sh h2{font-family:‘Syne’,sans-serif;font-size:1.9rem;font-weight:800;letter-spacing:-0.5px;}

.m-jobsgrid{display:grid;grid-template-columns:repeat(auto-fill,minmax(300px,1fr));gap:16px;}
.m-jobcard{background:var(–card);border:1px solid var(–border);border-radius:12px;padding:22px;cursor:pointer;transition:all 0.2s;position:relative;overflow:hidden;}
.m-jobcard:hover{transform:translateY(-2px);box-shadow:0 8px 24px rgba(0,0,0,0.08);border-color:var(–accent);}
.m-jobcard::before{content:’’;position:absolute;top:0;left:0;right:0;height:3px;background:var(–accent);transform:scaleX(0);transform-origin:left;transition:transform 0.2s;}
.m-jobcard:hover::before{transform:scaleX(1);}
.m-jobtop{display:flex;justify-content:space-between;align-items:flex-start;margin-bottom:10px;}
.m-jobcat{font-family:‘Syne’,sans-serif;font-size:0.65rem;font-weight:700;text-transform:uppercase;letter-spacing:1px;padding:3px 9px;border-radius:20px;background:var(–cream);color:var(–muted);}
.m-jobbudget{font-family:‘Syne’,sans-serif;font-size:0.95rem;font-weight:800;color:#2d6a4f;}
.m-jobtitle{font-family:‘Syne’,sans-serif;font-size:1rem;font-weight:700;margin-bottom:7px;line-height:1.3;}
.m-jobdesc{font-size:0.82rem;color:var(–muted);line-height:1.6;margin-bottom:14px;}
.m-jobfoot{display:flex;justify-content:space-between;align-items:center;}
.m-jobmeta{font-size:0.75rem;color:var(–muted);}
.m-bidbtn{background:var(–ink);color:var(–paper);padding:7px 14px;border-radius:6px;border:none;font-family:‘Syne’,sans-serif;font-weight:700;font-size:0.75rem;cursor:pointer;transition:all 0.2s;}
.m-bidbtn:hover{background:var(–accent);}
.m-urgent{font-size:0.65rem;font-weight:700;text-transform:uppercase;letter-spacing:1px;color:var(–accent);padding:3px 7px;background:rgba(232,68,10,0.1);border-radius:4px;}

.m-fgrid{display:grid;grid-template-columns:repeat(auto-fill,minmax(240px,1fr));gap:16px;}
.m-fcard{background:var(–card);border:1px solid var(–border);border-radius:12px;padding:22px;text-align:center;transition:all 0.2s;}
.m-fcard:hover{transform:translateY(-2px);box-shadow:0 8px 24px rgba(0,0,0,0.08);}
.m-favatar{width:60px;height:60px;border-radius:50%;margin:0 auto 10px;display:flex;align-items:center;justify-content:center;font-family:‘Syne’,sans-serif;font-weight:800;font-size:1.2rem;color:#fff;}
.m-fname{font-family:‘Syne’,sans-serif;font-weight:700;font-size:0.95rem;margin-bottom:3px;}
.m-ftitle{font-size:0.8rem;color:var(–muted);margin-bottom:10px;}
.m-ftags{display:flex;gap:5px;flex-wrap:wrap;justify-content:center;margin-bottom:12px;}
.m-ftag{font-size:0.68rem;padding:3px 9px;border-radius:20px;background:var(–cream);color:var(–ink);}
.m-frate{font-family:‘Syne’,sans-serif;font-weight:800;font-size:0.95rem;color:#2d6a4f;margin-bottom:12px;}
.m-hirebtn{width:100%;background:var(–ink);color:var(–paper);padding:9px;border-radius:7px;border:none;font-family:‘Syne’,sans-serif;font-weight:700;font-size:0.78rem;cursor:pointer;transition:all 0.2s;}
.m-hirebtn:hover{background:var(–accent);}

.m-postform{max-width:600px;margin:0 auto;background:var(–card);border:1px solid var(–border);border-radius:16px;padding:36px;}
.m-frow{margin-bottom:20px;}
.m-frow label{display:block;font-family:‘Syne’,sans-serif;font-weight:700;font-size:0.8rem;letter-spacing:0.5px;text-transform:uppercase;color:var(–ink);margin-bottom:7px;}
.m-frow input,.m-frow textarea,.m-frow select{width:100%;padding:11px 14px;border:1.5px solid var(–border);border-radius:8px;font-family:‘DM Sans’,sans-serif;font-size:0.92rem;color:var(–ink);background:var(–paper);outline:none;transition:border-color 0.2s;}
.m-frow input:focus,.m-frow textarea:focus,.m-frow select:focus{border-color:var(–accent);}
.m-frow textarea{min-height:100px;resize:vertical;}
.m-fgridrow{display:grid;grid-template-columns:1fr 1fr;gap:14px;}
.m-submitbtn{width:100%;padding:15px;background:var(–accent);color:#fff;border:none;border-radius:8px;font-family:‘Syne’,sans-serif;font-weight:800;font-size:0.95rem;cursor:pointer;transition:all 0.2s;}
.m-submitbtn:hover{background:#c93a08;}
.m-submitbtn:disabled{background:var(–muted);cursor:not-allowed;}

.m-howgrid{display:grid;grid-template-columns:repeat(3,1fr);gap:20px;}
.m-howcard{background:var(–card);border:1px solid var(–border);border-radius:12px;padding:26px;}
.m-hownum{font-family:‘Syne’,sans-serif;font-size:2.2rem;font-weight:800;color:var(–accent);opacity:0.3;line-height:1;margin-bottom:10px;}
.m-howcard h3{font-family:‘Syne’,sans-serif;font-weight:700;font-size:0.95rem;margin-bottom:7px;}
.m-howcard p{font-size:0.82rem;color:var(–muted);line-height:1.6;}

.m-revbanner{background:var(–ink);color:var(–paper);padding:44px 40px;text-align:center;}
.m-revbanner h2{font-family:‘Syne’,sans-serif;font-weight:800;font-size:1.7rem;margin-bottom:7px;letter-spacing:-0.5px;}
.m-revbanner h2 span{color:var(–accent);}
.m-revbanner p{color:rgba(255,255,255,0.5);font-size:0.88rem;margin-bottom:24px;}
.m-revcards{display:flex;gap:14px;justify-content:center;flex-wrap:wrap;}
.m-revcard{background:rgba(255,255,255,0.05);border:1px solid rgba(255,255,255,0.1);border-radius:12px;padding:22px 28px;min-width:180px;}
.m-revcardnum{font-family:‘Syne’,sans-serif;font-weight:800;font-size:1.7rem;color:var(–accent);}
.m-revcardlbl{font-size:0.75rem;color:rgba(255,255,255,0.4);margin-top:3px;text-transform:uppercase;letter-spacing:1px;}

/* ── SHARED MODAL ── */
.modal-overlay{display:none;position:fixed;inset:0;background:rgba(0,0,0,0.6);z-index:999;align-items:center;justify-content:center;padding:20px;}
.modal-overlay.open{display:flex;}
.modal-box{background:var(–card);border-radius:16px;padding:32px;max-width:460px;width:100%;position:relative;max-height:90vh;overflow-y:auto;}
.modal-x{position:absolute;top:14px;right:16px;background:none;border:none;font-size:1.3rem;cursor:pointer;color:var(–muted);}
.modal-box h3{font-family:‘Syne’,sans-serif;font-weight:800;font-size:1.2rem;margin-bottom:5px;}
.modal-sub{font-size:0.83rem;color:var(–muted);margin-bottom:20px;}
.modal-submit{width:100%;padding:13px;background:var(–accent);color:#fff;border:none;border-radius:8px;font-family:‘Syne’,sans-serif;font-weight:800;font-size:0.9rem;cursor:pointer;transition:all 0.2s;margin-top:4px;}
.modal-submit:hover{background:#c93a08;}
.modal-submit:disabled{background:var(–muted);cursor:not-allowed;}
.auth-tabs{display:flex;margin-bottom:22px;border:1.5px solid var(–border);border-radius:8px;overflow:hidden;}
.auth-tab{flex:1;padding:9px;text-align:center;cursor:pointer;font-family:‘Syne’,sans-serif;font-weight:700;font-size:0.8rem;background:transparent;border:none;color:var(–muted);transition:all 0.2s;}
.auth-tab.active{background:var(–ink);color:var(–paper);}

/* ── SHARED TOAST ── */
.toast{position:fixed;bottom:24px;right:24px;background:var(–ink);color:var(–paper);padding:13px 18px;border-radius:10px;font-family:‘Syne’,sans-serif;font-weight:700;font-size:0.82rem;z-index:9999;transform:translateY(80px);opacity:0;transition:all 0.3s;max-width:300px;}
.toast.show{transform:translateY(0);opacity:1;}
.toast.success{border-left:4px solid var(–green);}
.toast.error{border-left:4px solid var(–accent);}

/* ══════════════════════════════════
DASHBOARD (DARK) — shared styles
══════════════════════════════════ */
#page-client,#page-freelancer{background:var(–dk);color:var(–dktext);}
.dk-layout{display:flex;min-height:100vh;}
.dk-sidebar{width:220px;flex-shrink:0;background:var(–dksurface);border-right:1px solid var(–dkborder);display:flex;flex-direction:column;position:fixed;top:0;left:0;bottom:0;z-index:50;}
.dk-slogo{padding:22px 20px 18px;border-bottom:1px solid var(–dkborder);}
.dk-logotext{font-family:‘Syne’,sans-serif;font-weight:800;font-size:1.2rem;color:var(–dktext);letter-spacing:-0.5px;}
.dk-logosub{font-family:‘IBM Plex Mono’,monospace;font-size:0.6rem;color:var(–dkmuted);margin-top:2px;letter-spacing:1px;}
.dk-nav{padding:14px 0;flex:1;}
.dk-navitem{display:flex;align-items:center;gap:10px;padding:10px 20px;cursor:pointer;font-family:‘Syne’,sans-serif;font-weight:600;font-size:0.78rem;color:var(–dkmuted);transition:all 0.15s;letter-spacing:0.3px;border-left:2px solid transparent;}
.dk-navitem:hover{color:var(–dktext);background:var(–dksurface2);}
.dk-navitem.active{color:var(–dktext);border-left-color:var(–green);background:var(–dksurface2);}
.dk-navbadge{margin-left:auto;background:var(–green);color:#000;font-family:‘IBM Plex Mono’,monospace;font-size:0.6rem;padding:2px 6px;border-radius:20px;}
.dk-sfoot{padding:14px 18px;border-top:1px solid var(–dkborder);}
.dk-userchip{display:flex;align-items:center;gap:9px;}
.dk-userdot{width:30px;height:30px;border-radius:50%;background:var(–green);display:flex;align-items:center;justify-content:center;font-family:‘Syne’,sans-serif;font-weight:800;font-size:0.72rem;color:#000;flex-shrink:0;}
.dk-username{font-family:‘Syne’,sans-serif;font-weight:700;font-size:0.75rem;color:var(–dktext);}
.dk-userrole{font-size:0.65rem;color:var(–dkmuted);margin-top:1px;}
.dk-signout{margin-top:10px;width:100%;background:transparent;border:1px solid var(–dkborder);color:var(–dkmuted);padding:7px;border-radius:6px;font-family:‘Syne’,sans-serif;font-weight:700;font-size:0.7rem;cursor:pointer;transition:all 0.15s;letter-spacing:0.5px;}
.dk-signout:hover{border-color:var(–accent);color:var(–accent);}
.dk-main{margin-left:220px;flex:1;}
.dk-topbar{display:flex;align-items:center;justify-content:space-between;padding:18px 28px;border-bottom:1px solid var(–dkborder);background:var(–dksurface);position:sticky;top:0;z-index:40;}
.dk-tbtitle{font-family:‘Syne’,sans-serif;font-weight:800;font-size:1.05rem;letter-spacing:-0.3px;}
.dk-tbsub{font-family:‘IBM Plex Mono’,monospace;font-size:0.65rem;color:var(–dkmuted);margin-top:2px;}
.dk-tbtn{background:var(–green);color:#000;padding:9px 18px;border-radius:7px;border:none;font-family:‘Syne’,sans-serif;font-weight:700;font-size:0.78rem;cursor:pointer;transition:all 0.15s;}
.dk-tbtn:hover{background:#16a34a;}
.dk-view{display:none;padding:28px;}
.dk-view.active{display:block;}

.dk-statsrow{display:grid;grid-template-columns:repeat(4,1fr);gap:14px;margin-bottom:28px;}
.dk-statcard{background:var(–dksurface);border:1px solid var(–dkborder);border-radius:12px;padding:18px;position:relative;overflow:hidden;}
.dk-statcard::after{content:’’;position:absolute;top:0;left:0;right:0;height:2px;}
.dk-statcard.c-green::after{background:var(–green);}
.dk-statcard.c-orange::after{background:var(–accent);}
.dk-statcard.c-yellow::after{background:#f59e0b;}
.dk-statcard.c-purple::after{background:var(–purple);}
.dk-statlbl{font-family:‘IBM Plex Mono’,monospace;font-size:0.62rem;color:var(–dkmuted);letter-spacing:1px;text-transform:uppercase;margin-bottom:8px;}
.dk-statval{font-family:‘Syne’,sans-serif;font-weight:800;font-size:1.7rem;line-height:1;}
.dk-statval.c-green{color:var(–green);}
.dk-statval.c-orange{color:var(–accent);}
.dk-statval.c-yellow{color:#f59e0b;}
.dk-statval.c-purple{color:var(–purple);}
.dk-statchange{font-size:0.7rem;color:var(–dkmuted);margin-top:5px;}

.dk-sectitle{font-family:‘Syne’,sans-serif;font-weight:800;font-size:0.82rem;letter-spacing:1px;text-transform:uppercase;color:var(–dkmuted);margin-bottom:14px;}
.dk-tablewrap{background:var(–dksurface);border:1px solid var(–dkborder);border-radius:12px;overflow:hidden;margin-bottom:28px;}
.dk-thead{padding:11px 18px;background:var(–dksurface2);border-bottom:1px solid var(–dkborder);font-family:‘IBM Plex Mono’,monospace;font-size:0.62rem;color:var(–dkmuted);letter-spacing:1px;text-transform:uppercase;display:grid;}
.dk-trow{padding:14px 18px;border-bottom:1px solid var(–dkborder);align-items:center;transition:background 0.15s;display:grid;}
.dk-trow:last-child{border-bottom:none;}
.dk-trow:hover{background:var(–dksurface2);}

.dk-badge{display:inline-flex;align-items:center;gap:4px;padding:3px 9px;border-radius:20px;font-family:‘IBM Plex Mono’,monospace;font-size:0.62rem;letter-spacing:0.5px;white-space:nowrap;}
.dk-badge::before{content:’’;width:5px;height:5px;border-radius:50%;flex-shrink:0;}
.b-open{background:rgba(59,130,246,0.1);color:#3b82f6;}
.b-open::before{background:#3b82f6;}
.b-pending{background:rgba(245,158,11,0.1);color:#f59e0b;}
.b-pending::before{background:#f59e0b;}
.b-accepted{background:rgba(34,197,94,0.1);color:var(–green);}
.b-accepted::before{background:var(–green);}
.b-rejected{background:rgba(239,68,68,0.1);color:#ef4444;}
.b-rejected::before{background:#ef4444;}
.b-escrowed{background:rgba(168,85,247,0.1);color:var(–purple);}
.b-escrowed::before{background:var(–purple);}
.b-released{background:rgba(34,197,94,0.1);color:var(–green);}
.b-released::before{background:var(–green);}
.b-completed{background:rgba(34,197,94,0.1);color:var(–green);}
.b-completed::before{background:var(–green);}
.b-progress{background:rgba(245,158,11,0.1);color:#f59e0b;}
.b-progress::before{background:#f59e0b;}

.dk-releasebtn{background:rgba(34,197,94,0.1);color:var(–green);border:1px solid rgba(34,197,94,0.2);padding:6px 13px;border-radius:6px;font-family:‘Syne’,sans-serif;font-weight:700;font-size:0.7rem;cursor:pointer;transition:all 0.15s;}
.dk-releasebtn:hover{background:var(–green);color:#000;}
.dk-acceptbtn{background:rgba(34,197,94,0.1);color:var(–green);border:1px solid rgba(34,197,94,0.2);padding:7px 12px;border-radius:6px;font-family:‘Syne’,sans-serif;font-weight:700;font-size:0.72rem;cursor:pointer;transition:all 0.15s;}
.dk-acceptbtn:hover{background:var(–green);color:#000;}
.dk-rejectbtn{background:rgba(239,68,68,0.1);color:#ef4444;border:1px solid rgba(239,68,68,0.2);padding:7px 12px;border-radius:6px;font-family:‘Syne’,sans-serif;font-weight:700;font-size:0.72rem;cursor:pointer;transition:all 0.15s;}
.dk-rejectbtn:hover{background:#ef4444;color:#fff;}
.dk-bidnowbtn{background:rgba(34,197,94,0.1);color:var(–green);border:1px solid rgba(34,197,94,0.2);padding:8px 16px;border-radius:6px;font-family:‘Syne’,sans-serif;font-weight:700;font-size:0.73rem;cursor:pointer;transition:all 0.15s;white-space:nowrap;}
.dk-bidnowbtn:hover{background:var(–green);color:#000;}

.dk-bidsgrid{display:grid;grid-template-columns:repeat(auto-fill,minmax(280px,1fr));gap:14px;margin-bottom:28px;}
.dk-bidcard{background:var(–dksurface);border:1px solid var(–dkborder);border-radius:12px;padding:18px;}
.dk-bidtop{display:flex;justify-content:space-between;align-items:flex-start;margin-bottom:9px;}
.dk-bidtitle{font-family:‘Syne’,sans-serif;font-weight:700;font-size:0.88rem;line-height:1.3;}
.dk-bidamt{font-family:‘Syne’,sans-serif;font-weight:800;font-size:1rem;color:var(–green);margin-left:10px;white-space:nowrap;}
.dk-bidcat{font-family:‘IBM Plex Mono’,monospace;font-size:0.67rem;color:var(–dkmuted);margin-bottom:9px;}
.dk-bidletter{font-size:0.8rem;color:rgba(240,237,232,0.5);line-height:1.6;margin-bottom:12px;font-style:italic;}
.dk-bidfoot{display:flex;justify-content:space-between;align-items:center;}
.dk-biddate{font-family:‘IBM Plex Mono’,monospace;font-size:0.65rem;color:var(–dkmuted);}
.dk-bidactions{display:flex;gap:7px;margin-top:12px;}

.dk-jobitem{background:var(–dksurface);border:1px solid var(–dkborder);border-radius:12px;padding:18px;display:grid;grid-template-columns:1fr auto;gap:14px;align-items:center;transition:all 0.15s;cursor:pointer;margin-bottom:10px;}
.dk-jobitem:hover{border-color:var(–green);background:var(–dksurface2);}
.dk-jobitemtitle{font-family:‘Syne’,sans-serif;font-weight:700;font-size:0.92rem;margin-bottom:3px;}
.dk-jobitemmeta{font-family:‘IBM Plex Mono’,monospace;font-size:0.65rem;color:var(–dkmuted);}
.dk-jobitemdesc{font-size:0.8rem;color:rgba(232,240,235,0.5);margin-top:5px;line-height:1.5;}
.dk-jobitemright{text-align:right;}
.dk-jobitembudget{font-family:‘Syne’,sans-serif;font-weight:800;font-size:1.05rem;color:var(–green);margin-bottom:5px;}

.dk-profilecard{background:var(–dksurface);border:1px solid var(–dkborder);border-radius:12px;padding:26px;margin-bottom:18px;}
.dk-ptop{display:flex;align-items:center;gap:14px;margin-bottom:22px;padding-bottom:22px;border-bottom:1px solid var(–dkborder);}
.dk-pavatar{width:68px;height:68px;border-radius:50%;background:var(–green);display:flex;align-items:center;justify-content:center;font-family:‘Syne’,sans-serif;font-weight:800;font-size:1.4rem;color:#000;flex-shrink:0;}
.dk-pmeta h2{font-family:‘Syne’,sans-serif;font-weight:800;font-size:1.15rem;}
.dk-pmeta p{font-size:0.8rem;color:var(–dkmuted);margin-top:3px;}
.dk-field{margin-bottom:16px;}
.dk-field label{display:block;font-family:‘IBM Plex Mono’,monospace;font-size:0.65rem;color:var(–dkmuted);letter-spacing:1px;text-transform:uppercase;margin-bottom:7px;}
.dk-field input,.dk-field textarea,.dk-field select{width:100%;padding:10px 13px;background:var(–dksurface2);border:1px solid #2e2e2e;border-radius:8px;color:var(–dktext);font-family:‘DM Sans’,sans-serif;font-size:0.9rem;outline:none;transition:border-color 0.15s;}
.dk-field input:focus,.dk-field textarea:focus{border-color:var(–green);}
.dk-field textarea{min-height:85px;resize:vertical;}
.dk-fieldgrid{display:grid;grid-template-columns:1fr 1fr;gap:12px;}
.dk-savebtn{background:var(–green);color:#000;padding:11px 26px;border-radius:8px;border:none;font-family:‘Syne’,sans-serif;font-weight:800;font-size:0.85rem;cursor:pointer;transition:all 0.15s;}
.dk-savebtn:hover{background:#16a34a;}

.dk-earningscard{background:var(–dksurface);border:1px solid var(–dkborder);border-radius:12px;padding:22px;margin-bottom:28px;}
.dk-earntotal{font-family:‘Syne’,sans-serif;font-weight:800;font-size:1.9rem;color:var(–green);}
.dk-earnlbl{font-family:‘IBM Plex Mono’,monospace;font-size:0.65rem;color:var(–dkmuted);letter-spacing:1px;margin-top:2px;}
.dk-barchart{display:flex;gap:7px;align-items:flex-end;height:70px;margin-top:18px;}
.dk-barwrap{flex:1;display:flex;flex-direction:column;align-items:center;gap:5px;}
.dk-bar{width:100%;border-radius:4px 4px 0 0;background:rgba(34,197,94,0.15);min-height:4px;}
.dk-bar.has-val{background:var(–green);}
.dk-barlbl{font-family:‘IBM Plex Mono’,monospace;font-size:0.58rem;color:var(–dkmuted);}

.dk-confirmdialog{background:var(–dksurface);border:1px solid #2e2e2e;border-radius:16px;padding:30px;max-width:420px;width:100%;position:relative;}
.dk-confirmdialog h3{font-family:‘Syne’,sans-serif;font-weight:800;font-size:1.05rem;margin-bottom:5px;}
.dk-confirmdialog p{font-size:0.83rem;color:rgba(240,237,232,0.5);margin-bottom:20px;line-height:1.6;}
.dk-confirmbtn{flex:1;background:var(–green);color:#000;padding:11px;border-radius:8px;border:none;font-family:‘Syne’,sans-serif;font-weight:800;font-size:0.83rem;cursor:pointer;transition:all 0.15s;}
.dk-confirmbtn:hover{background:#16a34a;}
.dk-cancelbtn{flex:1;background:transparent;color:var(–dkmuted);padding:11px;border-radius:8px;border:1px solid var(–dkborder);font-family:‘Syne’,sans-serif;font-weight:700;font-size:0.83rem;cursor:pointer;transition:all 0.15s;}
.dk-cancelbtn:hover{color:var(–dktext);}

/* ── LOGIN SCREENS ── */
.dk-loginscreen{display:flex;align-items:center;justify-content:center;min-height:100vh;background:var(–dk);padding:20px;}
.dk-loginbox{background:var(–dksurface);border:1px solid var(–dkborder);border-radius:16px;padding:38px;width:100%;max-width:380px;}
.dk-loginlogo{font-family:‘Syne’,sans-serif;font-weight:800;font-size:1.5rem;margin-bottom:3px;}
.dk-loginlogo span{color:var(–green);}
.dk-loginsub{font-family:‘IBM Plex Mono’,monospace;font-size:0.67rem;color:var(–dkmuted);margin-bottom:28px;letter-spacing:1px;}
.dk-loginerr{font-size:0.78rem;color:var(–accent);margin-top:9px;text-align:center;min-height:18px;}
.dk-loginbtn{width:100%;padding:13px;background:var(–green);color:#000;border:none;border-radius:8px;font-family:‘Syne’,sans-serif;font-weight:800;font-size:0.88rem;cursor:pointer;transition:all 0.15s;margin-top:6px;}
.dk-loginbtn:hover{background:#16a34a;}
.dk-loginbtn:disabled{background:#2a3a2e;cursor:not-allowed;}
.dk-backlink{text-align:center;margin-top:16px;font-size:0.78rem;color:var(–dkmuted);cursor:pointer;}
.dk-backlink span{color:var(–green);}

.dk-empty{padding:44px 20px;text-align:center;}
.dk-empty-icon{font-size:2.2rem;margin-bottom:10px;opacity:0.25;}
.dk-empty h3{font-family:‘Syne’,sans-serif;font-weight:800;font-size:0.95rem;color:var(–dkmuted);margin-bottom:5px;}
.dk-empty p{font-size:0.8rem;color:#2a3a2e;}
.dk-loading{padding:36px;text-align:center;font-family:‘IBM Plex Mono’,monospace;font-size:0.7rem;color:var(–dkmuted);letter-spacing:2px;text-transform:uppercase;animation:pulse 1.5s infinite;}
@keyframes pulse{0%,100%{opacity:1}50%{opacity:0.3}}

/* ── RESPONSIVE ── */
@media(max-width:768px){
.m-nav,.m-tabs{padding-left:16px;padding-right:16px;}
.m-hero{grid-template-columns:1fr;gap:32px;padding:36px 16px;}
.m-h1{font-size:2.2rem;}
.m-section{padding:36px 16px;}
.m-howgrid{grid-template-columns:1fr;}
.m-fgridrow{grid-template-columns:1fr;}
.m-revbanner{padding:36px 16px;}
.dk-sidebar{display:none;}
.dk-main{margin-left:0;}
.dk-statsrow{grid-template-columns:1fr 1fr;}
.dk-view{padding:18px;}
.dk-fieldgrid{grid-template-columns:1fr;}
}
</style>

</head>
<body>

<!-- ══════════════════════════════════
     PAGE: MAIN MARKETPLACE
══════════════════════════════════ -->

<div id="page-main" class="page active">
  <nav class="m-nav">
    <div class="m-logo">Skill<span>Swap</span></div>
    <div class="m-navlinks" id="m-navlinks">
      <button class="m-nbtn m-ghost" onclick="openAuth('login')">Log In</button>
      <button class="m-nbtn m-solid" onclick="openAuth('signup')">Get Started Free</button>
    </div>
  </nav>
  <div class="m-tabs">
    <div class="m-tab active" onclick="mTab('home')">Home</div>
    <div class="m-tab" onclick="mTab('jobs')">Browse Jobs</div>
    <div class="m-tab" onclick="mTab('talent')">Find Talent</div>
    <div class="m-tab" onclick="mTab('post')">Post a Job</div>
  </div>

  <!-- HOME -->

  <div id="mv-home" class="m-view active">
    <div class="m-hero">
      <div>
        <div class="m-eyebrow">Freelance Marketplace</div>
        <h1 class="m-h1">Hire Fast.<br>Earn <em>Faster.</em></h1>
        <p class="m-hdesc">SkillSwap connects consumers and businesses with top freelancers in minutes. Post a job, get bids, pay securely.</p>
        <div class="m-ctas">
          <button class="m-btnp" onclick="mTab('post')">Post a Job — Free</button>
          <button class="m-btns" onclick="mTab('talent')">Browse Talent</button>
        </div>
      </div>
      <div class="m-statscard">
        <div><div class="m-statnum">2.4<span>K</span></div><div class="m-statlbl">Active Freelancers</div></div>
        <div><div class="m-statnum">98<span>%</span></div><div class="m-statlbl">Satisfaction Rate</div></div>
        <div class="m-statdiv"></div>
        <div><div class="m-statnum">$1<span>M+</span></div><div class="m-statlbl">Paid Out</div></div>
        <div><div class="m-statnum">48<span>hr</span></div><div class="m-statlbl">Avg Hire Time</div></div>
      </div>
    </div>
    <div class="m-section">
      <div class="m-sh"><div class="m-eyebrow">How It Works</div><h2>Three steps to done.</h2></div>
      <div class="m-howgrid">
        <div class="m-howcard"><div class="m-hownum">01</div><h3>Post Your Job</h3><p>Describe what you need, set a budget, publish in 2 minutes.</p></div>
        <div class="m-howcard"><div class="m-hownum">02</div><h3>Receive Bids</h3><p>Vetted freelancers send proposals within hours.</p></div>
        <div class="m-howcard"><div class="m-hownum">03</div><h3>Pay Safely</h3><p>Funds held in escrow via Stripe. Release when work is done.</p></div>
      </div>
    </div>
  </div>

  <!-- JOBS -->

  <div id="mv-jobs" class="m-view">
    <div class="m-section">
      <div class="m-sh"><div class="m-eyebrow">Open Opportunities</div><h2>Browse Live Jobs</h2></div>
      <div id="m-jobsgrid" class="m-jobsgrid"><div class="dk-loading">Loading jobs...</div></div>
    </div>
  </div>

  <!-- TALENT -->

  <div id="mv-talent" class="m-view">
    <div class="m-section">
      <div class="m-sh"><div class="m-eyebrow">Top Rated</div><h2>Find Talent</h2></div>
      <div id="m-fgrid" class="m-fgrid"><div class="dk-loading">Loading talent...</div></div>
    </div>
  </div>

  <!-- POST -->

  <div id="mv-post" class="m-view">
    <div class="m-section">
      <div class="m-sh" style="text-align:center"><div class="m-eyebrow">Get Started</div><h2>Post a Job</h2></div>
      <div class="m-postform">
        <div class="m-frow"><label>Job Title</label><input type="text" id="m-jtitle" placeholder="e.g. Build me a landing page"></div>
        <div class="m-frow"><label>Category</label>
          <select id="m-jcat">
            <option value="">Select category</option>
            <option>Web & App Development</option><option>Design & Creative</option>
            <option>Marketing & SEO</option><option>Writing & Content</option>
            <option>Video & Animation</option><option>Business & Finance</option>
            <option>Admin & Virtual Assistant</option>
          </select>
        </div>
        <div class="m-frow"><label>Description</label><textarea id="m-jdesc" placeholder="Describe what you need..."></textarea></div>
        <div class="m-fgridrow">
          <div class="m-frow"><label>Budget ($)</label><input type="number" id="m-jbudget" placeholder="500"></div>
          <div class="m-frow"><label>Deadline</label><input type="date" id="m-jdeadline"></div>
        </div>
        <div class="m-frow" style="display:flex;align-items:center;gap:9px">
          <input type="checkbox" id="m-jurgent" style="width:auto">
          <label for="m-jurgent" style="text-transform:none;font-size:0.88rem;margin:0">Mark as urgent</label>
        </div>
        <button class="m-submitbtn" id="m-postbtn" onclick="postJob()">Post Job — Free →</button>
      </div>
    </div>
  </div>

  <div class="m-revbanner">
    <h2>Built to <span>Make Money</span></h2>
    <p>SkillSwap earns on every transaction.</p>
    <div class="m-revcards">
      <div class="m-revcard"><div class="m-revcardnum">10%</div><div class="m-revcardlbl">Platform fee per job</div></div>
      <div class="m-revcard"><div class="m-revcardnum">$29/mo</div><div class="m-revcardlbl">Pro freelancer plan</div></div>
      <div class="m-revcard"><div class="m-revcardnum">$99/mo</div><div class="m-revcardlbl">Business listings</div></div>
    </div>
  </div>
</div>

<!-- ══════════════════════════════════
     PAGE: CLIENT DASHBOARD
══════════════════════════════════ -->

<div id="page-client" class="page">
  <div id="client-login">
    <div class="dk-loginscreen">
      <div class="dk-loginbox">
        <div class="dk-loginlogo">Skill<span>Swap</span></div>
        <div class="dk-loginsub">CLIENT DASHBOARD</div>
        <div class="dk-field"><label>Email</label><input type="email" id="cl-email" placeholder="you@email.com"></div>
        <div class="dk-field"><label>Password</label><input type="password" id="cl-pass" placeholder="••••••••" onkeydown="if(event.key==='Enter')clLogin()"></div>
        <button class="dk-loginbtn" id="cl-loginbtn" onclick="clLogin()">Access Dashboard →</button>
        <div class="dk-loginerr" id="cl-err"></div>
        <div class="dk-backlink" onclick="showPage('main')">← Back to <span>SkillSwap</span></div>
      </div>
    </div>
  </div>
  <div id="client-dash" style="display:none">
    <div class="dk-layout">
      <aside class="dk-sidebar">
        <div class="dk-slogo"><div class="dk-logotext">Skill<span style="color:var(--green)">Swap</span></div><div class="dk-logosub">CLIENT DASHBOARD</div></div>
        <nav class="dk-nav">
          <div class="dk-navitem active" onclick="clView('overview')"><span>◈</span>Overview</div>
          <div class="dk-navitem" onclick="clView('jobs')"><span>◻</span>My Jobs</div>
          <div class="dk-navitem" onclick="clView('bids')"><span>◎</span>Bids Received</div>
          <div class="dk-navitem" onclick="clView('payments')"><span>◆</span>Payments</div>
        </nav>
        <div class="dk-sfoot">
          <div class="dk-userchip"><div class="dk-userdot" id="cl-dot">?</div><div><div class="dk-username" id="cl-name">Loading...</div><div class="dk-userrole">Client</div></div></div>
          <button class="dk-signout" onclick="clSignOut()">SIGN OUT</button>
        </div>
      </aside>
      <main class="dk-main">
        <div class="dk-topbar">
          <div><div class="dk-tbtitle" id="cl-tbtitle">Overview</div><div class="dk-tbsub" id="cl-tbsub">Welcome back</div></div>
          <button class="dk-tbtn" onclick="showPage('main');mTab('post')">+ Post New Job</button>
        </div>
        <!-- OVERVIEW -->
        <div id="clv-overview" class="dk-view active">
          <div class="dk-statsrow">
            <div class="dk-statcard c-orange"><div class="dk-statlbl">Active Jobs</div><div class="dk-statval c-orange" id="cl-stat-active">—</div><div class="dk-statchange">open now</div></div>
            <div class="dk-statcard c-yellow"><div class="dk-statlbl">Bids Received</div><div class="dk-statval c-yellow" id="cl-stat-bids">—</div><div class="dk-statchange">pending review</div></div>
            <div class="dk-statcard c-purple"><div class="dk-statlbl">In Escrow</div><div class="dk-statval c-purple" id="cl-stat-escrow">—</div><div class="dk-statchange">held securely</div></div>
            <div class="dk-statcard c-green"><div class="dk-statlbl">Total Spent</div><div class="dk-statval c-green" id="cl-stat-spent">—</div><div class="dk-statchange">completed</div></div>
          </div>
          <div class="dk-sectitle">Recent Jobs</div>
          <div class="dk-tablewrap"><div class="dk-thead" style="grid-template-columns:2fr 1fr 1fr 1fr"><span>Title</span><span>Budget</span><span>Status</span><span>Posted</span></div><div id="cl-overview-jobs"><div class="dk-loading">Loading...</div></div></div>
          <div class="dk-sectitle">Pending Bids</div>
          <div class="dk-tablewrap"><div class="dk-thead" style="grid-template-columns:2fr 1fr 1fr 1fr"><span>Job</span><span>Freelancer</span><span>Amount</span><span>Action</span></div><div id="cl-overview-bids"><div class="dk-loading">Loading...</div></div></div>
        </div>
        <!-- MY JOBS -->
        <div id="clv-jobs" class="dk-view">
          <div class="dk-tablewrap"><div class="dk-thead" style="grid-template-columns:2fr 1fr 1fr 1fr"><span>Title</span><span>Budget</span><span>Status</span><span>Posted</span></div><div id="cl-jobs-table"><div class="dk-loading">Loading...</div></div></div>
        </div>
        <!-- BIDS -->
        <div id="clv-bids" class="dk-view"><div id="cl-bids-container"><div class="dk-loading">Loading...</div></div></div>
        <!-- PAYMENTS -->
        <div id="clv-payments" class="dk-view">
          <div class="dk-tablewrap"><div class="dk-thead" style="grid-template-columns:2fr 1fr 1fr 1fr 1fr"><span>Freelancer</span><span>Amount</span><span>Fee</span><span>Status</span><span>Action</span></div><div id="cl-payments-table"><div class="dk-loading">Loading...</div></div></div>
        </div>
      </main>
    </div>
  </div>
</div>

<!-- ══════════════════════════════════
     PAGE: FREELANCER DASHBOARD
══════════════════════════════════ -->

<div id="page-freelancer" class="page">
  <div id="fl-login">
    <div class="dk-loginscreen">
      <div class="dk-loginbox">
        <div class="dk-loginlogo">Skill<span>Swap</span></div>
        <div class="dk-loginsub">FREELANCER DASHBOARD</div>
        <div class="dk-field"><label>Email</label><input type="email" id="fl-email" placeholder="you@email.com"></div>
        <div class="dk-field"><label>Password</label><input type="password" id="fl-pass" placeholder="••••••••" onkeydown="if(event.key==='Enter')flLogin()"></div>
        <button class="dk-loginbtn" id="fl-loginbtn" onclick="flLogin()">Access Dashboard →</button>
        <div class="dk-loginerr" id="fl-err"></div>
        <div class="dk-backlink" onclick="showPage('main')">← Back to <span>SkillSwap</span></div>
      </div>
    </div>
  </div>
  <div id="fl-dash" style="display:none">
    <div class="dk-layout">
      <aside class="dk-sidebar">
        <div class="dk-slogo"><div class="dk-logotext">Skill<span style="color:var(--green)">Swap</span></div><div class="dk-logosub">FREELANCER DASHBOARD</div></div>
        <nav class="dk-nav">
          <div class="dk-navitem active" onclick="flView('overview')"><span>◈</span>Overview</div>
          <div class="dk-navitem" onclick="flView('browse')"><span>◻</span>Browse Jobs</div>
          <div class="dk-navitem" onclick="flView('bids')"><span>◎</span>My Bids <span class="dk-navbadge" id="fl-badge" style="display:none">0</span></div>
          <div class="dk-navitem" onclick="flView('earnings')"><span>◆</span>Earnings</div>
          <div class="dk-navitem" onclick="flView('profile')"><span>◉</span>My Profile</div>
        </nav>
        <div class="dk-sfoot">
          <div class="dk-userchip"><div class="dk-userdot" id="fl-dot">?</div><div><div class="dk-username" id="fl-name">Loading...</div><div class="dk-userrole">Freelancer</div></div></div>
          <button class="dk-signout" onclick="flSignOut()">SIGN OUT</button>
        </div>
      </aside>
      <main class="dk-main">
        <div class="dk-topbar">
          <div><div class="dk-tbtitle" id="fl-tbtitle">Overview</div><div class="dk-tbsub" id="fl-tbsub">Your freelance command center</div></div>
          <button class="dk-tbtn" onclick="flView('browse')">Browse Jobs →</button>
        </div>
        <!-- OVERVIEW -->
        <div id="flv-overview" class="dk-view active">
          <div class="dk-statsrow">
            <div class="dk-statcard c-green"><div class="dk-statlbl">Total Earned</div><div class="dk-statval c-green" id="fl-stat-earned">$0</div><div class="dk-statchange">released</div></div>
            <div class="dk-statcard c-purple"><div class="dk-statlbl">In Escrow</div><div class="dk-statval c-purple" id="fl-stat-escrow">$0</div><div class="dk-statchange">pending release</div></div>
            <div class="dk-statcard c-yellow"><div class="dk-statlbl">Active Bids</div><div class="dk-statval c-yellow" id="fl-stat-bids">0</div><div class="dk-statchange">under review</div></div>
            <div class="dk-statcard c-orange"><div class="dk-statlbl">Jobs Won</div><div class="dk-statval c-orange" id="fl-stat-won">0</div><div class="dk-statchange">accepted bids</div></div>
          </div>
          <div class="dk-sectitle">Recent Bids</div>
          <div class="dk-tablewrap"><div class="dk-thead" style="grid-template-columns:2fr 1fr 1fr 1fr"><span>Job</span><span>My Bid</span><span>Status</span><span>Date</span></div><div id="fl-overview-bids"><div class="dk-loading">Loading...</div></div></div>
          <div class="dk-sectitle">Incoming Payments</div>
          <div class="dk-tablewrap"><div class="dk-thead" style="grid-template-columns:2fr 1fr 1fr 1fr"><span>Client</span><span>Amount</span><span>My Cut</span><span>Status</span></div><div id="fl-overview-payments"><div class="dk-loading">Loading...</div></div></div>
        </div>
        <!-- BROWSE -->
        <div id="flv-browse" class="dk-view">
          <select id="fl-catfilter" onchange="flLoadBrowse()" style="background:var(--dksurface);border:1px solid #2e2e2e;color:var(--dktext);padding:8px 13px;border-radius:8px;font-family:'IBM Plex Mono',monospace;font-size:0.7rem;outline:none;cursor:pointer;margin-bottom:18px;display:block">
            <option value="">All Categories</option>
            <option>Web & App Development</option><option>Design & Creative</option>
            <option>Marketing & SEO</option><option>Writing & Content</option>
            <option>Video & Animation</option><option>Business & Finance</option>
            <option>Admin & Virtual Assistant</option>
          </select>
          <div id="fl-browse-jobs"><div class="dk-loading">Loading jobs...</div></div>
        </div>
        <!-- MY BIDS -->
        <div id="flv-bids" class="dk-view"><div id="fl-bids-container"><div class="dk-loading">Loading...</div></div></div>
        <!-- EARNINGS -->
        <div id="flv-earnings" class="dk-view">
          <div class="dk-earningscard">
            <div style="display:flex;justify-content:space-between;align-items:flex-start">
              <div><div class="dk-earntotal" id="fl-earntotal">$0</div><div class="dk-earnlbl">TOTAL EARNED</div></div>
              <div style="text-align:right"><div style="font-family:'Syne',sans-serif;font-weight:800;font-size:1.2rem;color:var(--purple)" id="fl-escrowtotal">$0</div><div class="dk-earnlbl">IN ESCROW</div></div>
            </div>
            <div class="dk-barchart" id="fl-barchart"></div>
          </div>
          <div class="dk-sectitle">Payment History</div>
          <div class="dk-tablewrap"><div class="dk-thead" style="grid-template-columns:2fr 1fr 1fr 1fr 1fr"><span>Client</span><span>Gross</span><span>Fee</span><span>You Get</span><span>Status</span></div><div id="fl-earnings-table"><div class="dk-loading">Loading...</div></div></div>
        </div>
        <!-- PROFILE -->
        <div id="flv-profile" class="dk-view">
          <div class="dk-profilecard">
            <div class="dk-ptop"><div class="dk-pavatar" id="fl-pavatar">?</div><div class="dk-pmeta"><h2 id="fl-pname">Your Name</h2><p id="fl-pemail"></p></div></div>
            <div class="dk-fieldgrid">
              <div class="dk-field"><label>Full Name</label><input type="text" id="fl-pname-input" placeholder="Your name"></div>
              <div class="dk-field"><label>Hourly Rate ($)</label><input type="number" id="fl-prate" placeholder="75"></div>
            </div>
            <div class="dk-fieldgrid">
              <div class="dk-field"><label>Location</label><input type="text" id="fl-plocation" placeholder="New York, USA"></div>
              <div class="dk-field"><label>Skills (comma separated)</label><input type="text" id="fl-pskills" placeholder="React, Figma, SEO"></div>
            </div>
            <div class="dk-field"><label>Bio</label><textarea id="fl-pbio" placeholder="Tell clients why you're the best hire..."></textarea></div>
            <button class="dk-savebtn" onclick="flSaveProfile()">Save Profile →</button>
          </div>
        </div>
      </main>
    </div>
  </div>
</div>

<!-- SHARED MODAL -->

<div class="modal-overlay" id="shared-modal" onclick="if(event.target===this)closeModal()">
  <div id="modal-inner"></div>
</div>

<!-- TOAST -->

<div class="toast" id="toast"></div>

<script>
// ============================================================
// CONFIG — KEYS ALREADY INSERTED
// ============================================================
var SB_URL = 'https://cowwlpiatpyiadrllkzr.supabase.co';
var SB_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNvd3dscGlhdHB5aWFkcmxsa3pyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQ2NzY1MTMsImV4cCI6MjA5MDI1MjUxM30.afIHLIsLDmjaVVfZrYhmqtSMMhXhcv4KTdZ0yYN9Eno';
var STRIPE_PK = 'pk_live_51QacVCPXrTVBuNYIbb58kzPH4jMdwIfnGKGTjl4GivUJYkKXgaorM64jFkAALlGwIfZONaypgAq4vsPYaRTGOTty00923mzNFO';

var sb = window.supabase.createClient(SB_URL, SB_KEY);
var stripe = Stripe(STRIPE_PK);
var clUser = null; var clProfile = null;
var flUser = null; var flProfile = null;
var pendingReleaseId = null;
var COLORS = ['#2d3a8c','#7c2d92','#c93a08','#2d6a4f','#a35c00','#1a4a6b'];

// ============================================================
// PAGE ROUTER
// ============================================================
function showPage(name) {
  var pages = ['main','client','freelancer'];
  for (var i = 0; i < pages.length; i++) {
    document.getElementById('page-' + pages[i]).classList.remove('active');
  }
  document.getElementById('page-' + name).classList.add('active');
  window.scrollTo(0,0);
}

// ============================================================
// MAIN MARKETPLACE TABS
// ============================================================
function mTab(name) {
  var views = ['home','jobs','talent','post'];
  var tabs = document.querySelectorAll('.m-tab');
  for (var i = 0; i < views.length; i++) {
    document.getElementById('mv-' + views[i]).classList.remove('active');
    tabs[i].classList.remove('active');
  }
  document.getElementById('mv-' + name).classList.add('active');
  tabs[views.indexOf(name)].classList.add('active');
  window.scrollTo(0,0);
  if (name === 'jobs') mLoadJobs();
  if (name === 'talent') mLoadTalent();
}

// ============================================================
// MAIN — AUTH MODAL
// ============================================================
function openAuth(mode) {
  renderAuthModal(mode);
  document.getElementById('shared-modal').classList.add('open');
}

function renderAuthModal(mode) {
  var isLogin = mode === 'login';
  var html = '<div class="modal-box">';
  html += '<button class="modal-x" onclick="closeModal()">×</button>';
  html += '<div class="auth-tabs"><button class="auth-tab ' + (isLogin?'active':'') + '" onclick="renderAuthModal(\'login\')">Log In</button><button class="auth-tab ' + (!isLogin?'active':'') + '" onclick="renderAuthModal(\'signup\')">Sign Up</button></div>';
  if (isLogin) {
    html += '<h3>Welcome Back</h3><p class="modal-sub">Log into SkillSwap.</p>';
    html += '<div class="m-frow"><label>Email</label><input type="email" id="a-email" placeholder="you@email.com"></div>';
    html += '<div class="m-frow"><label>Password</label><input type="password" id="a-pass" placeholder="••••••••"></div>';
    html += '<button class="modal-submit" id="a-btn" onclick="doLogin()">Log In →</button>';
    html += '<p style="text-align:center;margin-top:14px;font-size:0.78rem;color:var(--muted)">Client dashboard: <span style="color:var(--accent);cursor:pointer;font-weight:700" onclick="closeModal();showPage(\'client\')">Go here</span> &nbsp;|&nbsp; Freelancer: <span style="color:var(--accent);cursor:pointer;font-weight:700" onclick="closeModal();showPage(\'freelancer\')">Go here</span></p>';
  } else {
    html += '<h3>Join SkillSwap</h3><p class="modal-sub">Free to join.</p>';
    html += '<div class="m-frow"><label>Full Name</label><input type="text" id="a-name" placeholder="Your name"></div>';
    html += '<div class="m-frow"><label>Email</label><input type="email" id="a-email" placeholder="you@email.com"></div>';
    html += '<div class="m-frow"><label>Password</label><input type="password" id="a-pass" placeholder="Min 6 characters"></div>';
    html += '<div class="m-frow"><label>I am a...</label><select id="a-role"><option value="client">Client / Company</option><option value="freelancer">Freelancer / Small Business</option></select></div>';
    html += '<button class="modal-submit" id="a-btn" onclick="doSignup()">Create Free Account →</button>';
  }
  html += '</div>';
  document.getElementById('modal-inner').innerHTML = html;
}

function doLogin() {
  var email = document.getElementById('a-email').value;
  var pass = document.getElementById('a-pass').value;
  if (!email || !pass) { toast('Please fill in all fields','error'); return; }
  var btn = document.getElementById('a-btn');
  btn.disabled = true; btn.textContent = 'Logging in...';
  sb.auth.signInWithPassword({ email:email, password:pass }).then(function(res) {
    if (res.error) { toast(res.error.message,'error'); btn.disabled=false; btn.textContent='Log In →'; }
    else { toast('Welcome back!','success'); closeModal(); mUpdateNav(res.data.user); }
  });
}

function doSignup() {
  var name = document.getElementById('a-name').value;
  var email = document.getElementById('a-email').value;
  var pass = document.getElementById('a-pass').value;
  var role = document.getElementById('a-role').value;
  if (!name||!email||!pass) { toast('Please fill in all fields','error'); return; }
  var btn = document.getElementById('a-btn');
  btn.disabled=true; btn.textContent='Creating...';
  sb.auth.signUp({ email:email, password:pass, options:{ data:{ full_name:name } } }).then(function(res) {
    if (res.error) { toast(res.error.message,'error'); btn.disabled=false; btn.textContent='Create Free Account →'; return; }
    sb.from('profiles').update({ full_name:name, role:role }).eq('id', res.data.user.id).then(function(){});
    toast('Account created! Check your email.','success');
    closeModal();
  });
}

function mUpdateNav(user) {
  if (!user) {
    document.getElementById('m-navlinks').innerHTML = '<button class="m-nbtn m-ghost" onclick="openAuth(\'login\')">Log In</button><button class="m-nbtn m-solid" onclick="openAuth(\'signup\')">Get Started Free</button>';
    return;
  }
  sb.from('profiles').select('full_name,role').eq('id',user.id).single().then(function(res) {
    var name = res.data ? res.data.full_name : user.email;
    var role = res.data ? res.data.role : 'client';
    var dashPage = role === 'freelancer' ? 'freelancer' : 'client';
    document.getElementById('m-navlinks').innerHTML =
      '<span class="m-navuser">Hi, ' + esc(name?name.split(' ')[0]:'there') + '</span>' +
      '<span class="m-dashlink" onclick="showPage(\'' + dashPage + '\');' + (dashPage==='client'?'clBoot()':'flBoot()') + '">My Dashboard</span>' +
      '<button class="m-nbtn m-ghost" onclick="sb.auth.signOut().then(function(){mUpdateNav(null)})">Sign Out</button>';
  });
}

// check if already logged in
sb.auth.getSession().then(function(res) {
  if (res.data && res.data.session) mUpdateNav(res.data.session.user);
});

// ============================================================
// MAIN — JOBS
// ============================================================
function mLoadJobs() {
  sb.from('jobs').select('*').eq('status','open').order('created_at',{ascending:false}).then(function(res) {
    var g = document.getElementById('m-jobsgrid');
    if (!res.data||res.data.length===0) { g.innerHTML='<div class="dk-empty"><div class="dk-empty-icon">◻</div><h3>No jobs yet</h3><p>Post the first one!</p></div>'; return; }
    var html='';
    for (var i=0;i<res.data.length;i++) {
      var j=res.data[i];
      var dl=j.deadline?new Date(j.deadline).toLocaleDateString('en-US',{month:'short',day:'numeric'}):'Open';
      html+='<div class="m-jobcard" onclick="mOpenBidModal(\''+j.id+'\',\''+esc(j.title)+'\','+j.budget+')">';
      html+='<div class="m-jobtop"><span class="m-jobcat">'+esc(j.category||'General')+'</span><span class="m-jobbudget">$'+(j.budget||'?')+'</span></div>';
      html+='<div class="m-jobtitle">'+esc(j.title)+'</div>';
      html+='<div class="m-jobdesc">'+esc((j.description||'').substring(0,100))+'...</div>';
      html+='<div class="m-jobfoot"><div class="m-jobmeta">Deadline: '+dl+'</div>';
      if(j.urgent) html+='<span class="m-urgent">Urgent</span>';
      else html+='<button class="m-bidbtn">Bid →</button>';
      html+='</div></div>';
    }
    g.innerHTML=html;
  });
}

function mOpenBidModal(jobId, title, budget) {
  sb.auth.getSession().then(function(res) {
    if (!res.data||!res.data.session) { openAuth('signup'); return; }
    var html='<div class="modal-box"><button class="modal-x" onclick="closeModal()">×</button>';
    html+='<h3>'+title+'</h3><p class="modal-sub">Budget: $'+budget+'</p>';
    html+='<div class="m-frow"><label>Your Bid ($)</label><input type="number" id="bid-amt" placeholder="'+budget+'"></div>';
    html+='<div class="m-frow"><label>Cover Letter</label><textarea id="bid-letter" placeholder="Why are you the best fit?"></textarea></div>';

```
html+='<button class="modal-submit" id="bid-btn" onclick="mSubmitBid(\''+jobId+'\')">Submit Bid →</button></div>';
document.getElementById('modal-inner').innerHTML=html;
document.getElementById('shared-modal').classList.add('open');
```

});
}

function mSubmitBid(jobId) {
var amt=parseFloat(document.getElementById(‘bid-amt’).value);
var letter=document.getElementById(‘bid-letter’).value;
if(!amt){toast(‘Enter your bid amount’,‘error’);return;}
var btn=document.getElementById(‘bid-btn’);
btn.disabled=true; btn.textContent=‘Submitting…’;
sb.auth.getSession().then(function(res) {
sb.from(‘bids’).insert([{job_id:jobId,freelancer_id:res.data.session.user.id,amount:amt,cover_letter:letter,status:‘pending’}]).then(function(r) {
if(r.error){toast(r.error.message.indexOf(‘unique’)>-1?‘Already bid on this job’:r.error.message,‘error’);btn.disabled=false;btn.textContent=‘Submit Bid →’;}
else{toast(‘Bid submitted! Good luck 🎯’,‘success’);closeModal();}
});
});
}

// ============================================================
// MAIN — TALENT
// ============================================================
function mLoadTalent() {
sb.from(‘profiles’).select(’*’).eq(‘role’,‘freelancer’).order(‘created_at’,{ascending:false}).then(function(res) {
var g=document.getElementById(‘m-fgrid’);
if(!res.data||res.data.length===0){g.innerHTML=’<div class="dk-empty"><div class="dk-empty-icon">◉</div><h3>No freelancers yet</h3><p>Sign up as a freelancer to be listed.</p></div>’;return;}
var html=’’;
for(var i=0;i<res.data.length;i++){
var f=res.data[i];
var init=(f.full_name||’?’).split(’ ‘).map(function(n){return n[0];}).join(’’).substring(0,2).toUpperCase();
var color=COLORS[i%COLORS.length];
var tags=f.skills&&f.skills.length?f.skills.slice(0,3):[‘Freelancer’];
var tagsHtml=’’;for(var t=0;t<tags.length;t++)tagsHtml+=’<span class="m-ftag">’+esc(tags[t])+’</span>’;
html+=’<div class="m-fcard">’;
html+=’<div class="m-favatar" style="background:'+color+'">’+init+’</div>’;
html+=’<div class="m-fname">’+esc(f.full_name||‘Anonymous’)+’</div>’;
html+=’<div class="m-ftitle">’+esc(f.bio?f.bio.substring(0,50):‘Freelancer’)+’</div>’;
html+=’<div class="m-ftags">’+tagsHtml+’</div>’;
if(f.hourly_rate)html+=’<div class="m-frate">$’+f.hourly_rate+’/hr</div>’;
html+=’<button class="m-hirebtn" onclick="mHireModal(\''+f.id+'\',\''+esc(f.full_name||'Freelancer')+'\')">Hire ‘+esc((f.full_name||‘Freelancer’).split(’ ‘)[0])+’ →</button>’;
html+=’</div>’;
}
g.innerHTML=html;
});
}

function mHireModal(fId, name) {
sb.auth.getSession().then(function(res) {
if(!res.data||!res.data.session){openAuth(‘signup’);return;}
var html=’<div class="modal-box"><button class="modal-x" onclick="closeModal()">×</button>’;
html+=’<h3>Hire ‘+name+’</h3><p class="modal-sub">Payment held in escrow until work is done.</p>’;
html+=’<div class="m-frow"><label>Job Amount ($)</label><input type="number" id="hire-amt" placeholder="500"></div>’;
html+=’<div class="m-frow"><label>Message</label><textarea id="hire-msg" placeholder="Describe the project..."></textarea></div>’;
html+=’<p style="font-size:0.75rem;color:var(--muted);text-align:center;margin-bottom:12px">10% platform fee added at checkout</p>’;
html+=’<button class="modal-submit" id="hire-btn" onclick="mProcessPayment(\''+fId+'\',\''+name+'\')">Pay & Hire ‘+name.split(’ ‘)[0]+’ →</button></div>’;
document.getElementById(‘modal-inner’).innerHTML=html;
document.getElementById(‘shared-modal’).classList.add(‘open’);
});
}

function mProcessPayment(fId, name) {
var amt=parseFloat(document.getElementById(‘hire-amt’).value);
if(!amt){toast(‘Enter the job amount’,‘error’);return;}
var btn=document.getElementById(‘hire-btn’);
btn.disabled=true; btn.textContent=‘Processing…’;
sb.auth.getSession().then(function(res) {
var uid=res.data.session.user.id;
var fee=amt*0.10;
sb.from(‘payments’).insert([{client_id:uid,freelancer_id:fId,amount:amt,platform_fee:fee,stripe_payment_intent_id:‘pi_demo_’+Date.now(),status:‘escrowed’}]).then(function(r) {
if(r.error){toast(‘Error: ‘+r.error.message,‘error’);btn.disabled=false;btn.textContent=‘Pay & Hire →’;}
else{toast(‘Payment escrowed! $’+amt.toFixed(2)+’ held securely.’,‘success’);closeModal();}
});
});
}

// ============================================================
// MAIN — POST JOB
// ============================================================
function postJob() {
sb.auth.getSession().then(function(res) {
if(!res.data||!res.data.session){openAuth(‘signup’);toast(‘Please log in to post a job’,‘error’);return;}
var title=document.getElementById(‘m-jtitle’).value;
var cat=document.getElementById(‘m-jcat’).value;
var desc=document.getElementById(‘m-jdesc’).value;
var budget=parseFloat(document.getElementById(‘m-jbudget’).value);
var deadline=document.getElementById(‘m-jdeadline’).value;
var urgent=document.getElementById(‘m-jurgent’).checked;
if(!title||!cat||!desc||!budget){toast(‘Please fill in all fields’,‘error’);return;}
var btn=document.getElementById(‘m-postbtn’);
btn.disabled=true;btn.textContent=‘Posting…’;
sb.from(‘jobs’).insert([{client_id:res.data.session.user.id,title:title,category:cat,description:desc,budget:budget,deadline:deadline||null,urgent:urgent,status:‘open’}]).then(function(r) {
if(r.error){toast(‘Error: ‘+r.error.message,‘error’);btn.disabled=false;btn.textContent=‘Post Job — Free →’;}
else{toast(‘Job posted!’,‘success’);document.getElementById(‘m-jtitle’).value=’’;document.getElementById(‘m-jdesc’).value=’’;document.getElementById(‘m-jbudget’).value=’’;btn.disabled=false;btn.textContent=‘Post Job — Free →’;setTimeout(function(){mTab(‘jobs’);},1500);}
});
});
}

// ============================================================
// CLIENT DASHBOARD
// ============================================================
function clLogin() {
var email=document.getElementById(‘cl-email’).value;
var pass=document.getElementById(‘cl-pass’).value;
var err=document.getElementById(‘cl-err’);
var btn=document.getElementById(‘cl-loginbtn’);
if(!email||!pass){err.textContent=‘Please enter email and password.’;return;}
btn.disabled=true;btn.textContent=‘Signing in…’;
sb.auth.signInWithPassword({email:email,password:pass}).then(function(res) {
if(res.error){err.textContent=res.error.message;btn.disabled=false;btn.textContent=‘Access Dashboard →’;}
else{clUser=res.data.user;clBoot();}
});
}

function clBoot() {
if(!clUser){sb.auth.getSession().then(function(r){if(r.data&&r.data.session){clUser=r.data.session.user;clBoot();}});return;}
document.getElementById(‘client-login’).style.display=‘none’;
document.getElementById(‘client-dash’).style.display=‘block’;
sb.from(‘profiles’).select(’*’).eq(‘id’,clUser.id).single().then(function(res) {
if(res.data){clProfile=res.data;var n=res.data.full_name||clUser.email;var init=n.split(’ ‘).map(function(x){return x[0];}).join(’’).substring(0,2).toUpperCase();document.getElementById(‘cl-dot’).textContent=init;document.getElementById(‘cl-name’).textContent=n.split(’ ’)[0];document.getElementById(‘cl-tbsub’).textContent=’Welcome back, ‘+n.split(’ ’)[0];}
});
clLoadStats();clLoadOverviewJobs();clLoadOverviewBids();
}

function clSignOut(){sb.auth.signOut().then(function(){clUser=null;document.getElementById(‘client-dash’).style.display=‘none’;document.getElementById(‘client-login’).style.display=‘block’;showPage(‘main’);});}

function clView(name) {
var views=[‘overview’,‘jobs’,‘bids’,‘payments’];
var items=document.querySelectorAll(’#page-client .dk-navitem’);
for(var i=0;i<views.length;i++){document.getElementById(‘clv-’+views[i]).classList.remove(‘active’);items[i].classList.remove(‘active’);}
document.getElementById(‘clv-’+name).classList.add(‘active’);
items[views.indexOf(name)].classList.add(‘active’);
document.getElementById(‘cl-tbtitle’).textContent={overview:‘Overview’,jobs:‘My Jobs’,bids:‘Bids Received’,payments:‘Payments’}[name];
if(name===‘jobs’)clLoadJobsView();
if(name===‘bids’)clLoadBidsView();
if(name===‘payments’)clLoadPaymentsView();
}

function clLoadStats() {
sb.from(‘jobs’).select(‘id’,{count:‘exact’}).eq(‘client_id’,clUser.id).eq(‘status’,‘open’).then(function(r){document.getElementById(‘cl-stat-active’).textContent=r.count||0;});
sb.from(‘jobs’).select(‘id’).eq(‘client_id’,clUser.id).then(function(jr) {
if(!jr.data||jr.data.length===0){document.getElementById(‘cl-stat-bids’).textContent=0;return;}
var ids=jr.data.map(function(j){return j.id;});
sb.from(‘bids’).select(‘id’,{count:‘exact’}).in(‘job_id’,ids).eq(‘status’,‘pending’).then(function(r){document.getElementById(‘cl-stat-bids’).textContent=r.count||0;});
});
sb.from(‘payments’).select(‘amount,platform_fee,status’).eq(‘client_id’,clUser.id).then(function(r) {
if(!r.data)return;var esc2=0;var spent=0;
for(var i=0;i<r.data.length;i++){var t=(r.data[i].amount||0)+(r.data[i].platform_fee||0);if(r.data[i].status===‘escrowed’||r.data[i].status===‘pending’)esc2+=t;if(r.data[i].status===‘released’)spent+=t;}
document.getElementById(‘cl-stat-escrow’).textContent=’$’+esc2.toFixed(0);
document.getElementById(‘cl-stat-spent’).textContent=’$’+spent.toFixed(0);
});
}

function clLoadOverviewJobs() {
sb.from(‘jobs’).select(’*’).eq(‘client_id’,clUser.id).order(‘created_at’,{ascending:false}).limit(5).then(function(r){clRenderJobsTable(‘cl-overview-jobs’,r.data);});
}

function clRenderJobsTable(elId, data) {
var el=document.getElementById(elId);
if(!data||data.length===0){el.innerHTML=’<div class="dk-empty"><div class="dk-empty-icon">◻</div><h3>No jobs yet</h3></div>’;return;}
var html=’’;
for(var i=0;i<data.length;i++){
var j=data[i];var dt=new Date(j.created_at).toLocaleDateString(‘en-US’,{month:‘short’,day:‘numeric’});
var sc=‘b-’+(j.status===‘in_progress’?‘progress’:j.status);var sl=j.status===‘in_progress’?‘IN PROGRESS’:j.status.toUpperCase();
html+=’<div class="dk-trow" style="grid-template-columns:2fr 1fr 1fr 1fr">’;
html+=’<span style="font-family:\'Syne\',sans-serif;font-weight:700;font-size:0.83rem">’+esc(j.title)+’</span>’;
html+=’<span style="font-family:\'Syne\',sans-serif;font-weight:700;color:var(--green)">$’+(j.budget||’?’)+’</span>’;
html+=’<span><span class="dk-badge '+sc+'">’+sl+’</span></span>’;
html+=’<span style="font-family:\'IBM Plex Mono\',monospace;font-size:0.68rem;color:var(--dkmuted)">’+dt+’</span>’;
html+=’</div>’;
}
el.innerHTML=html;
}

function clLoadOverviewBids() {
sb.from(‘jobs’).select(‘id,title’).eq(‘client_id’,clUser.id).then(function(jr) {
if(!jr.data||jr.data.length===0){document.getElementById(‘cl-overview-bids’).innerHTML=’<div class="dk-empty"><div class="dk-empty-icon">◎</div><h3>No bids yet</h3></div>’;return;}
var jmap={};jr.data.forEach(function(j){jmap[j.id]=j.title;});
var ids=jr.data.map(function(j){return j.id;});
sb.from(‘bids’).select(’*,profiles(full_name)’).in(‘job_id’,ids).eq(‘status’,‘pending’).limit(5).then(function(r) {
if(!r.data||r.data.length===0){document.getElementById(‘cl-overview-bids’).innerHTML=’<div class="dk-empty"><div class="dk-empty-icon">◎</div><h3>No pending bids</h3></div>’;return;}
var html=’’;
for(var i=0;i<r.data.length;i++){
var b=r.data[i];var fn=b.profiles?b.profiles.full_name:‘Unknown’;
html+=’<div class="dk-trow" style="grid-template-columns:2fr 1fr 1fr 1fr">’;
html+=’<span style="font-family:\'Syne\',sans-serif;font-weight:700;font-size:0.83rem">’+esc(jmap[b.job_id]||‘Job’)+’</span>’;
html+=’<span style="font-size:0.82rem;color:rgba(240,237,232,0.6)">’+esc(fn)+’</span>’;
html+=’<span style="font-family:\'Syne\',sans-serif;font-weight:700;color:var(--green)">$’+b.amount+’</span>’;
html+=’<div style="display:flex;gap:6px"><button class="dk-acceptbtn" onclick="clAcceptBid(\''+b.id+'\',\''+b.job_id+'\')">✓</button><button class="dk-rejectbtn" onclick="clRejectBid(\''+b.id+'\')">✕</button></div>’;
html+=’</div>’;
}
document.getElementById(‘cl-overview-bids’).innerHTML=html;
});
});
}

function clLoadJobsView(){sb.from(‘jobs’).select(’*’).eq(‘client_id’,clUser.id).order(‘created_at’,{ascending:false}).then(function(r){clRenderJobsTable(‘cl-jobs-table’,r.data);});}

function clLoadBidsView() {
sb.from(‘jobs’).select(‘id,title’).eq(‘client_id’,clUser.id).then(function(jr) {
if(!jr.data||jr.data.length===0){document.getElementById(‘cl-bids-container’).innerHTML=’<div class="dk-empty"><div class="dk-empty-icon">◎</div><h3>No bids yet</h3></div>’;return;}
var jmap={};jr.data.forEach(function(j){jmap[j.id]=j.title;});
var ids=jr.data.map(function(j){return j.id;});
sb.from(‘bids’).select(’*,profiles(full_name)’).in(‘job_id’,ids).order(‘created_at’,{ascending:false}).then(function(r) {
if(!r.data||r.data.length===0){document.getElementById(‘cl-bids-container’).innerHTML=’<div class="dk-empty"><div class="dk-empty-icon">◎</div><h3>No bids received</h3></div>’;return;}
var html=’<div class="dk-bidsgrid">’;
for(var i=0;i<r.data.length;i++){
var b=r.data[i];var fn=b.profiles?b.profiles.full_name:‘Unknown’;
var init=fn.split(’ ‘).map(function(n){return n[0];}).join(’’).substring(0,2).toUpperCase();
html+=’<div class="dk-bidcard">’;
html+=’<div class="dk-bidtop"><div style="display:flex;align-items:center;gap:9px"><div style="width:34px;height:34px;border-radius:50%;background:'+COLORS[i%COLORS.length]+';display:flex;align-items:center;justify-content:center;font-family:\'Syne\',sans-serif;font-weight:800;font-size:0.72rem;color:#fff">’+init+’</div><div><div class="dk-bidtitle">’+esc(fn)+’</div><div class="dk-bidcat">’+esc(jmap[b.job_id]||‘Job’)+’</div></div></div><div class="dk-bidamt">$’+b.amount+’</div></div>’;
if(b.cover_letter)html+=’<div class="dk-bidletter">”’+esc(b.cover_letter.substring(0,140))+’”</div>’;
html+=’<div class="dk-bidfoot"><span class="dk-badge b-'+b.status+'">’+b.status.toUpperCase()+’</span>’;
if(b.status===‘pending’)html+=’<div class="dk-bidactions"><button class="dk-acceptbtn" onclick="clAcceptBid(\''+b.id+'\',\''+b.job_id+'\')">✓ Accept</button><button class="dk-rejectbtn" onclick="clRejectBid(\''+b.id+'\')">✕ Reject</button></div>’;
html+=’</div></div>’;
}
html+=’</div>’;
document.getElementById(‘cl-bids-container’).innerHTML=html;
});
});
}

function clAcceptBid(bidId,jobId){sb.from(‘bids’).update({status:‘accepted’}).eq(‘id’,bidId).then(function(){sb.from(‘jobs’).update({status:‘in_progress’}).eq(‘id’,jobId).then(function(){});toast(‘Bid accepted!’,‘success’);clLoadOverviewBids();clLoadStats();});}
function clRejectBid(bidId){sb.from(‘bids’).update({status:‘rejected’}).eq(‘id’,bidId).then(function(){toast(‘Bid rejected.’,‘success’);clLoadOverviewBids();clLoadStats();});}

function clLoadPaymentsView() {
sb.from(‘payments’).select(’*,profiles!payments_freelancer_id_fkey(full_name)’).eq(‘client_id’,clUser.id).order(‘created_at’,{ascending:false}).then(function(r) {
var el=document.getElementById(‘cl-payments-table’);
if(!r.data||r.data.length===0){el.innerHTML=’<div class="dk-empty"><div class="dk-empty-icon">◆</div><h3>No payments yet</h3></div>’;return;}
var html=’’;
for(var i=0;i<r.data.length;i++){
var p=r.data[i];var fn=p.profiles?p.profiles.full_name:‘Unknown’;var total=((p.amount||0)+(p.platform_fee||0)).toFixed(2);
html+=’<div class="dk-trow" style="grid-template-columns:2fr 1fr 1fr 1fr 1fr">’;
html+=’<span style="font-family:\'Syne\',sans-serif;font-weight:700;font-size:0.83rem">’+esc(fn)+’</span>’;
html+=’<span style="font-family:\'Syne\',sans-serif;font-weight:700;color:var(--green)">$’+total+’</span>’;
html+=’<span style="font-family:\'IBM Plex Mono\',monospace;font-size:0.7rem;color:var(--dkmuted)">$’+(p.platform_fee||0).toFixed(2)+’</span>’;
html+=’<span><span class="dk-badge b-'+p.status+'">’+p.status.toUpperCase()+’</span></span>’;
if(p.status===‘escrowed’||p.status===‘pending’)html+=’<span><button class="dk-releasebtn" onclick="clConfirmRelease(\''+p.id+'\','+total+')">Release →</button></span>’;
else html+=’<span style="color:var(--dkmuted);font-size:0.7rem">—</span>’;
html+=’</div>’;
}
el.innerHTML=html;
});
}

function clConfirmRelease(payId,amt) {
pendingReleaseId=payId;
var html=’<div class="dk-confirmdialog"><button class="modal-x" onclick="closeModal()" style="color:var(--dkmuted)">×</button>’;
html+=’<h3>Release Payment?</h3><p>This will release <strong style="color:var(--green)">$’+amt+’</strong> to the freelancer. Only do this when satisfied with the work. Cannot be undone.</p>’;
html+=’<div style="display:flex;gap:10px"><button class="dk-confirmbtn" onclick="clDoRelease()">Yes, Release</button><button class="dk-cancelbtn" onclick="closeModal()">Cancel</button></div></div>’;
document.getElementById(‘modal-inner’).innerHTML=html;
document.getElementById(‘shared-modal’).classList.add(‘open’);
}

function clDoRelease() {
if(!pendingReleaseId)return;
sb.from(‘payments’).update({status:‘released’}).eq(‘id’,pendingReleaseId).then(function(r) {
closeModal();
if(r.error)toast(‘Error releasing payment’,‘error’);
else{toast(‘Payment released to freelancer!’,‘success’);clLoadPaymentsView();clLoadStats();}
pendingReleaseId=null;
});
}

// ============================================================
// FREELANCER DASHBOARD
// ============================================================
function flLogin() {
var email=document.getElementById(‘fl-email’).value;
var pass=document.getElementById(‘fl-pass’).value;
var err=document.getElementById(‘fl-err’);
var btn=document.getElementById(‘fl-loginbtn’);
if(!email||!pass){err.textContent=‘Please enter email and password.’;return;}
btn.disabled=true;btn.textContent=‘Signing in…’;
sb.auth.signInWithPassword({email:email,password:pass}).then(function(res) {
if(res.error){err.textContent=res.error.message;btn.disabled=false;btn.textContent=‘Access Dashboard →’;}
else{flUser=res.data.user;flBoot();}
});
}

function flBoot() {
if(!flUser){sb.auth.getSession().then(function(r){if(r.data&&r.data.session){flUser=r.data.session.user;flBoot();}});return;}
document.getElementById(‘fl-login’).style.display=‘none’;
document.getElementById(‘fl-dash’).style.display=‘block’;
sb.from(‘profiles’).select(’*’).eq(‘id’,flUser.id).single().then(function(res) {
if(res.data){flProfile=res.data;var n=res.data.full_name||flUser.email;var init=n.split(’ ‘).map(function(x){return x[0];}).join(’’).substring(0,2).toUpperCase();
document.getElementById(‘fl-dot’).textContent=init;document.getElementById(‘fl-name’).textContent=n.split(’ ‘)[0];document.getElementById(‘fl-tbsub’).textContent=‘Welcome back, ‘+n.split(’ ‘)[0];
document.getElementById(‘fl-pname-input’).value=res.data.full_name||’’;document.getElementById(‘fl-prate’).value=res.data.hourly_rate||’’;document.getElementById(‘fl-plocation’).value=res.data.location||’’;document.getElementById(‘fl-pskills’).value=res.data.skills?res.data.skills.join(’, ‘):’’;document.getElementById(‘fl-pbio’).value=res.data.bio||’’;
document.getElementById(‘fl-pavatar’).textContent=init;document.getElementById(‘fl-pname’).textContent=n;document.getElementById(‘fl-pemail’).textContent=flUser.email;}
});
flLoadStats();flLoadOverviewBids();flLoadOverviewPayments();
}

function flSignOut(){sb.auth.signOut().then(function(){flUser=null;document.getElementById(‘fl-dash’).style.display=‘none’;document.getElementById(‘fl-login’).style.display=‘block’;showPage(‘main’);});}

function flView(name) {
var views=[‘overview’,‘browse’,‘bids’,‘earnings’,‘profile’];
var items=document.querySelectorAll(’#page-freelancer .dk-navitem’);
for(var i=0;i<views.length;i++){document.getElementById(‘flv-’+views[i]).classList.remove(‘active’);items[i].classList.remove(‘active’);}
document.getElementById(‘flv-’+name).classList.add(‘active’);
items[views.indexOf(name)].classList.add(‘active’);
document.getElementById(‘fl-tbtitle’).textContent={overview:‘Overview’,browse:‘Browse Jobs’,bids:‘My Bids’,earnings:‘Earnings’,profile:‘My Profile’}[name];
if(name===‘browse’)flLoadBrowse();
if(name===‘bids’)flLoadBidsView();
if(name===‘earnings’)flLoadEarnings();
}

function flLoadStats() {
sb.from(‘bids’).select(‘id,status’).eq(‘freelancer_id’,flUser.id).then(function(r) {
if(!r.data)return;var p=0;var w=0;
for(var i=0;i<r.data.length;i++){if(r.data[i].status===‘pending’)p++;if(r.data[i].status===‘accepted’)w++;}
document.getElementById(‘fl-stat-bids’).textContent=p;document.getElementById(‘fl-stat-won’).textContent=w;
if(p>0){var b=document.getElementById(‘fl-badge’);b.textContent=p;b.style.display=‘inline-block’;}
});
sb.from(‘payments’).select(‘amount,status’).eq(‘freelancer_id’,flUser.id).then(function(r) {
if(!r.data)return;var earned=0;var esc2=0;
for(var i=0;i<r.data.length;i++){if(r.data[i].status===‘released’)earned+=r.data[i].amount||0;if(r.data[i].status===‘escrowed’||r.data[i].status===‘pending’)esc2+=r.data[i].amount||0;}
document.getElementById(‘fl-stat-earned’).textContent=’$’+earned.toFixed(0);document.getElementById(‘fl-stat-escrow’).textContent=’$’+esc2.toFixed(0);
});
}

function flLoadOverviewBids() {
sb.from(‘bids’).select(’*,jobs(title,budget)’).eq(‘freelancer_id’,flUser.id).order(‘created_at’,{ascending:false}).limit(5).then(function(r) {
var el=document.getElementById(‘fl-overview-bids’);
if(!r.data||r.data.length===0){el.innerHTML=’<div class="dk-empty"><div class="dk-empty-icon">◎</div><h3>No bids yet</h3></div>’;return;}
var html=’’;
for(var i=0;i<r.data.length;i++){
var b=r.data[i];var job=b.jobs||{};var dt=new Date(b.created_at).toLocaleDateString(‘en-US’,{month:‘short’,day:‘numeric’});
html+=’<div class="dk-trow" style="grid-template-columns:2fr 1fr 1fr 1fr">’;
html+=’<span style="font-family:\'Syne\',sans-serif;font-weight:700;font-size:0.83rem">’+esc(job.title||‘Job’)+’</span>’;
html+=’<span style="font-family:\'Syne\',sans-serif;font-weight:700;color:var(--green)">$’+b.amount+’</span>’;
html+=’<span><span class="dk-badge b-'+b.status+'">’+b.status.toUpperCase()+’</span></span>’;
html+=’<span style="font-family:\'IBM Plex Mono\',monospace;font-size:0.68rem;color:var(--dkmuted)">’+dt+’</span>’;
html+=’</div>’;
}
el.innerHTML=html;
});
}

function flLoadOverviewPayments() {
sb.from(‘payments’).select(’*,profiles!payments_client_id_fkey(full_name)’).eq(‘freelancer_id’,flUser.id).order(‘created_at’,{ascending:false}).limit(5).then(function(r) {
var el=document.getElementById(‘fl-overview-payments’);
if(!r.data||r.data.length===0){el.innerHTML=’<div class="dk-empty"><div class="dk-empty-icon">◆</div><h3>No payments yet</h3></div>’;return;}
var html=’’;
for(var i=0;i<r.data.length;i++){
var p=r.data[i];var cn=p.profiles?p.profiles.full_name:‘Client’;
html+=’<div class="dk-trow" style="grid-template-columns:2fr 1fr 1fr 1fr">’;
html+=’<span style="font-family:\'Syne\',sans-serif;font-weight:700;font-size:0.83rem">’+esc(cn)+’</span>’;
html+=’<span style="color:var(--green);font-family:\'Syne\',sans-serif;font-weight:700">$’+(p.amount||0).toFixed(2)+’</span>’;
html+=’<span style="color:var(--green);font-family:\'Syne\',sans-serif;font-weight:700">$’+(p.amount||0).toFixed(2)+’</span>’;
html+=’<span><span class="dk-badge b-'+p.status+'">’+p.status.toUpperCase()+’</span></span>’;
html+=’</div>’;
}
el.innerHTML=html;
});
}

function flLoadBrowse() {
var cat=document.getElementById(‘fl-catfilter’).value;
var q=sb.from(‘jobs’).select(’*’).eq(‘status’,‘open’).order(‘created_at’,{ascending:false});
if(cat)q=q.eq(‘category’,cat);
q.then(function(r) {
var el=document.getElementById(‘fl-browse-jobs’);
if(!r.data||r.data.length===0){el.innerHTML=’<div class="dk-empty"><div class="dk-empty-icon">◻</div><h3>No open jobs</h3><p>Check back soon.</p></div>’;return;}
var html=’’;
for(var i=0;i<r.data.length;i++){
var j=r.data[i];var dl=j.deadline?new Date(j.deadline).toLocaleDateString(‘en-US’,{month:‘short’,day:‘numeric’}):‘Open’;
html+=’<div class="dk-jobitem" onclick="flOpenBidModal(\''+j.id+'\',\''+esc(j.title)+'\','+j.budget+',\''+esc(j.category||'')+'\' )">’;
html+=’<div><div class="dk-jobitemtitle">’+esc(j.title)+(j.urgent?’ <span style="font-size:0.62rem;color:var(--accent);font-family:\'IBM Plex Mono\',monospace">URGENT</span>’:’’)+’</div>’;
html+=’<div class="dk-jobitemmeta">’+esc(j.category||‘General’)+’ · Deadline: ‘+dl+’</div>’;
if(j.description)html+=’<div class="dk-jobitemdesc">’+esc(j.description.substring(0,90))+’…</div>’;
html+=’</div><div class="dk-jobitemright"><div class="dk-jobitembudget">$’+(j.budget||’?’)+’</div><button class="dk-bidnowbtn">Bid Now →</button></div></div>’;
}
el.innerHTML=html;
});
}

function flOpenBidModal(jobId,title,budget,cat) {
var html=’<div class="modal-box"><button class="modal-x" onclick="closeModal()" style="color:var(--dkmuted)">×</button>’;
html+=’<h3 style="color:var(--dktext)">’+title+’</h3><p style="color:var(--dkmuted);font-size:0.82rem;margin-bottom:16px">’+cat+’ · Budget: $’+budget+’</p>’;
html+=’<div class="dk-field"><label>Your Bid ($)</label><input type="number" id="fl-bid-amt" placeholder="'+budget+'"></div>’;
html+=’<div class="dk-field"><label>Cover Letter</label><textarea id="fl-bid-letter" placeholder="Tell the client why you\'re perfect..."></textarea></div>’;
html+=’<button class="dk-loginbtn" id="fl-bid-btn" onclick="flSubmitBid(\''+jobId+'\')">Submit Bid →</button></div>’;
document.getElementById(‘modal-inner’).innerHTML=html;
document.getElementById(‘shared-modal’).classList.add(‘open’);
}

function flSubmitBid(jobId) {
var amt=parseFloat(document.getElementById(‘fl-bid-amt’).value);
var letter=document.getElementById(‘fl-bid-letter’).value;
if(!amt){toast(‘Enter your bid amount’,‘error’);return;}
var btn=document.getElementById(‘fl-bid-btn’);
btn.disabled=true;btn.textContent=‘Submitting…’;
sb.from(‘bids’).insert([{job_id:jobId,freelancer_id:flUser.id,amount:amt,cover_letter:letter,status:‘pending’}]).then(function(r) {
if(r.error){toast(r.error.message.indexOf(‘unique’)>-1?‘Already bid on this job’:r.error.message,‘error’);btn.disabled=false;btn.textContent=‘Submit Bid →’;}
else{toast(‘Bid submitted! Good luck 🎯’,‘success’);closeModal();flLoadStats();}
});
}

function flLoadBidsView() {
sb.from(‘bids’).select(’*,jobs(title,budget,category)’).eq(‘freelancer_id’,flUser.id).order(‘created_at’,{ascending:false}).then(function(r) {
var el=document.getElementById(‘fl-bids-container’);
if(!r.data||r.data.length===0){el.innerHTML=’<div class="dk-empty"><div class="dk-empty-icon">◎</div><h3>No bids yet</h3><p>Browse jobs and start bidding.</p></div>’;return;}
var html=’<div class="dk-bidsgrid">’;
for(var i=0;i<r.data.length;i++){
var b=r.data[i];var job=b.jobs||{};var dt=new Date(b.created_at).toLocaleDateString(‘en-US’,{month:‘short’,day:‘numeric’});
html+=’<div class="dk-bidcard"><div class="dk-bidtop"><div><div class="dk-bidtitle">’+esc(job.title||‘Job’)+’</div><div class="dk-bidcat">’+esc(job.category||‘General’)+’ · Budget: $’+(job.budget||’?’)+’</div></div><div class="dk-bidamt">$’+b.amount+’</div></div>’;
if(b.cover_letter)html+=’<div class="dk-bidletter">”’+esc(b.cover_letter.substring(0,130))+’”</div>’;
html+=’<div class="dk-bidfoot"><span class="dk-badge b-'+b.status+'">’+b.status.toUpperCase()+’</span><span class="dk-biddate">’+dt+’</span></div></div>’;
}
html+=’</div>’;el.innerHTML=html;
});
}

function flLoadEarnings() {
sb.from(‘payments’).select(’*,profiles!payments_client_id_fkey(full_name)’).eq(‘freelancer_id’,flUser.id).order(‘created_at’,{ascending:false}).then(function(r) {
var data=r.data||[];var earned=0;var escrow2=0;var monthly={};
for(var i=0;i<data.length;i++){
var p=data[i];var month=new Date(p.created_at).toLocaleDateString(‘en-US’,{month:‘short’});
if(!monthly[month])monthly[month]=0;
if(p.status===‘released’){earned+=p.amount||0;monthly[month]+=p.amount||0;}
if(p.status===‘escrowed’||p.status===‘pending’)escrow2+=p.amount||0;
}
document.getElementById(‘fl-earntotal’).textContent=’$’+earned.toFixed(0);
document.getElementById(‘fl-escrowtotal’).textContent=’$’+escrow2.toFixed(0);
var months=Object.keys(monthly);var maxV=0;for(var m=0;m<months.length;m++)if(monthly[months[m]]>maxV)maxV=monthly[months[m]];
var chartHtml=’’;
if(months.length===0)chartHtml=’<div style="font-family:\'IBM Plex Mono\',monospace;font-size:0.7rem;color:var(--dkmuted);padding:16px 0">No earnings yet</div>’;
for(var m=0;m<months.length;m++){var pct=maxV>0?(monthly[months[m]]/maxV*100):0;chartHtml+=’<div class="dk-barwrap"><div class="dk-bar '+(pct>0?'has-val':'')+'" style="height:'+Math.max(pct,5)+'%"></div><div class="dk-barlbl">’+months[m]+’</div></div>’;}
document.getElementById(‘fl-barchart’).innerHTML=chartHtml;
var el=document.getElementById(‘fl-earnings-table’);
if(data.length===0){el.innerHTML=’<div class="dk-empty"><div class="dk-empty-icon">◆</div><h3>No payments yet</h3></div>’;return;}
var html=’’;
for(var i=0;i<data.length;i++){
var p=data[i];var cn=p.profiles?p.profiles.full_name:‘Client’;var gross=(p.amount||0)+(p.platform_fee||0);
html+=’<div class="dk-trow" style="grid-template-columns:2fr 1fr 1fr 1fr 1fr">’;
html+=’<span style="font-family:\'Syne\',sans-serif;font-weight:700;font-size:0.83rem">’+esc(cn)+’</span>’;
html+=’<span style="color:rgba(240,237,232,0.4);font-size:0.82rem">$’+gross.toFixed(2)+’</span>’;
html+=’<span style="color:var(--accent);font-size:0.82rem">-$’+(p.platform_fee||0).toFixed(2)+’</span>’;
html+=’<span style="font-family:\'Syne\',sans-serif;font-weight:800;color:var(--green)">$’+(p.amount||0).toFixed(2)+’</span>’;
html+=’<span><span class="dk-badge b-'+p.status+'">’+p.status.toUpperCase()+’</span></span>’;
html+=’</div>’;
}
el.innerHTML=html;
});
}

function flSaveProfile() {
var updates={full_name:document.getElementById(‘fl-pname-input’).value,bio:document.getElementById(‘fl-pbio’).value,hourly_rate:parseFloat(document.getElementById(‘fl-prate’).value)||null,location:document.getElementById(‘fl-plocation’).value,skills:document.getElementById(‘fl-pskills’).value.split(’,’).map(function(s){return s.trim();}).filter(Boolean),role:‘freelancer’};
sb.from(‘profiles’).update(updates).eq(‘id’,flUser.id).then(function(r) {
if(r.error)toast(‘Error saving profile’,‘error’);
else{var n=updates.full_name||flUser.email;var init=n.split(’ ‘).map(function(x){return x[0];}).join(’’).substring(0,2).toUpperCase();document.getElementById(‘fl-dot’).textContent=init;document.getElementById(‘fl-name’).textContent=n.split(’ ’)[0];document.getElementById(‘fl-pavatar’).textContent=init;document.getElementById(‘fl-pname’).textContent=n;toast(‘Profile saved! Now listed in Find Talent.’,‘success’);}
});
}

// ============================================================
// UTILS
// ============================================================
function esc(s){if(!s)return’’;return String(s).replace(/&/g,’&’).replace(/</g,’<’).replace(/>/g,’>’).replace(/”/g,’"’);}
function toast(msg,type){var t=document.getElementById(‘toast’);t.textContent=msg;t.className=‘toast ‘+(type||’’);t.classList.add(‘show’);setTimeout(function(){t.classList.remove(‘show’);},3500);}
function closeModal(){document.getElementById(‘shared-modal’).classList.remove(‘open’);}
</script>

</body>
</html>
