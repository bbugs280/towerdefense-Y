# New World Value — Marketing & Distribution Plan

**Version:** 1.0  
**Created:** 2026-04-02  
**Last Updated:** 2026-04-02  
**Owner:** Vincent  

---

## 📅 Weekly Rhythm

| Day | Task | Time | Owner |
|-----|------|------|-------|
| **Wednesday 9am HKT** | Publish essay + podcast on Substack | 30 min | Vincent |
| **Wednesday 9:30am HKT** | Create bitly links (Read + Listen) | 2 min | Vincent |
| **Wednesday 10am-12pm HKT** | Manual post: X, WhatsApp, Telegram, LinkedIn | 15 min | Vincent |
| **Thursday 9am HKT** | GenSpark Browser posts: X, IG, Quora | 10 min | Vincent + AI |

---

## 🎯 Primary Distribution Channels

| Channel | Priority | Post Day | Content Type | Effort |
|---------|----------|----------|--------------|--------|
| **Substack** | 🔴 Primary | Wed | Full essay + podcast | 2-3 hrs |
| **X.com (Twitter)** | 🔴 High | Wed + Thu | Teaser + bitly links | 5 min |
| **Instagram** | 🟡 Medium | Thu | Reel/Story + caption | 5 min |
| **Quora** | 🟡 Medium | Thu | Answer questions + link | 10 min |
| **WhatsApp** | 🟡 Medium | Wed | Broadcast to subscribers | 2 min |
| **Telegram** | 🟡 Medium | Wed | Channel post | 2 min |
| **LinkedIn** | 🟢 Low | Wed (optional) | Professional post | 5 min |

---

## 📝 Content Templates (Copy-Paste Ready)

See: `marketing/copy-templates.md` for full templates.

### X.com (Twitter)
```
What happens to your money if the dollar keeps falling?

Down 9.4% last year. 30-year low in reserves. Now a war.

I mapped 3 scenarios — slow bleed, fast decline, crash — and what to do in each.

Read: [bitly]
Listen: [bitly]
```

### Instagram (Reel/Story Caption)
```
💵 The dollar is falling. What do you do?

New World Value Week [X]: [Title]

[1-2 sentence hook]

Link in bio → Full essay + podcast

#newworldvalue #dollar #investing #geopolitics #economics #personalfinance #money
```

### Quora (Answer Template)
```
[Hook — direct answer in 1-2 sentences]

[Body — 300-500 words of genuine value with data]

I wrote a full analysis on this with [X] scenarios + historical precedents. 
Free to read: [bitly link]

Happy to discuss — what aspect worries you most?
```

---

## 🤖 GenSpark Browser Automation (Thursday)

**Workflow:**
1. Open GenSpark Browser
2. Paste the GenSpark prompt (see: `marketing/genspark-prompt.md`)
3. GenSpark posts to X, IG, Quora automatically
4. Review and confirm posts went live
5. Log results in metrics tracker

**What GenSpark Does:**
- Logs into X, IG, Quora (credentials stored in GenSpark)
- Posts teaser to X with bitly links
- Posts Reel/Story to IG with caption
- Finds 3 relevant Quora questions, posts answers with links

**What You Still Do Manually:**
- WhatsApp broadcast (personal touch)
- Telegram channel post (quick copy-paste)
- Engage with comments throughout the week

---

## 📊 Metrics to Track (Weekly)

| Metric | Source | Target (Month 1) | Actual |
|--------|--------|------------------|--------|
| Substack subscribers | Substack dashboard | 500 | |
| Open rate | Substack dashboard | 45%+ | |
| Click-through rate | Substack dashboard | 8%+ | |
| X impressions | X Analytics | 5,000 | |
| X link clicks | bitly dashboard | 200 | |
| IG followers | Instagram | 200 | |
| Quora answer views | Quora dashboard | 1,000 | |
| Quora link clicks | bitly dashboard | 100 | |

**Review:** Every Thursday after posting (5 min)

---

## 🗂️ File Structure

```
projects/new-world-value/marketing/
├── README.md                    # This file
├── copy-templates.md            # All social media templates
├── genspark-prompt.md           # Prompt for GenSpark Browser automation
├── metrics-tracker.md           # Weekly metrics log
└── launch-playbook.md           # First 4 weeks checklist
```

---

## ✅ Thursday Posting Checklist (GenSpark)

- [ ] Essay published on Substack (Wed)
- [ ] Podcast uploaded (Wed)
- [ ] bitly links created (Read + Listen)
- [ ] GenSpark prompt filled with:
  - [ ] Week number
  - [ ] Essay title
  - [ ] Hook (3 data points)
  - [ ] bitly Read link
  - [ ] bitly Listen link
  - [ ] 3 Quora question URLs
- [ ] Run GenSpark Browser automation
- [ ] Verify posts went live (X, IG, Quora)
- [ ] Log metrics in tracker

---

## 🚨 Troubleshooting

| Issue | Fix |
|-------|-----|
| GenSpark can't log in | Re-authenticate credentials in GenSpark settings |
| X post fails (character limit) | Shorten hook — each data line under 50 chars |
| IG post fails | Check image/video format (1080x1920 for Reels) |
| Quora answer flagged | Add more original analysis, reduce promotional tone |
| bitly links not tracking | Use bitly.com to create new links, ensure UTM tags |

---

## 📞 Escalation

If automation fails 2+ weeks in a row:
1. Revert to manual posting (templates in `copy-templates.md`)
2. Debug GenSpark credentials
3. Consider native platform schedulers (X has built-in scheduler)

---

**Last Reviewed:** 2026-04-02  
**Next Review:** 2026-04-09 (after Week 2 post)
