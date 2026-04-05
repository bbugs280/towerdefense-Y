# Paw Mind — TODO & Bugs

## 🐛 Bugs

### [BUG] Negative feedback input timeout
**Priority:** High  
**Reported:** 2026-04-04  
**Status:** Open  

**Issue:** When user gives negative feedback, the system doesn't have enough time to type the correct input message before timing out or moving on.

**Impact:** Poor user experience during feedback correction flow. Users cannot properly correct misunderstandings.

**Reproduction:**
1. User provides input
2. AI responds incorrectly
3. User gives negative feedback (e.g., "wrong", "no", "that's not what I meant")
4. System fails to capture correct input message in time

**Possible Causes:**
- Input timeout too short for negative feedback scenarios
- Missing debounce/throttle on feedback detection
- State machine not waiting for follow-up clarification

**Next Steps:**
- [ ] Review input handling timeout settings
- [ ] Add explicit "wait for clarification" state after negative feedback
- [ ] Test with longer input windows for correction flows
- [ ] Consider adding "Did you mean...?" suggestions after negative feedback

---

## 📋 TODO

### POC Phase
- [ ] Complete POC scaffold (iOS Native + Hybrid)
- [ ] Latency testing for on-device vision
- [ ] **Test latency: HK → Singapore endpoint (Alibaba Cloud)**
- [ ] Test Cantonese output variations
- [ ] User testing with 5-10 dog owners

### MVP Phase
- [ ] Finalize prompt engineering
- [ ] Build camera + skeleton integration
- [ ] Create app prototype
- [ ] **Verify Singapore endpoint pricing (International tier)**
- [ ] App store submission prep

### Future (Post-MVP)
- [ ] Multi-region routing logic (US→Virginia, EU→Frankfurt)
- [ ] Mainland China expansion plan (requires ICP license — defer)

---

## Last Updated
2026-04-04
