# GitHub Copilot

##  Use case

Yes, you absolutely can. In 2026, the integration between GitHub Issues and Copilot is seamless, especially with the GitHub Copilot Workspace and the Copilot Agent features.

Here is the exact workflow to create an issue for a README.md and have Copilot fix it according to your specific instructions.

## 🔍 Is the "Fix README" feature included?

The ability to assign work to Copilot from an issue is categorized as an "Agentic" or "Workspace" feature. Here is how the cost breaks down for that specific task:

🔹 On the Free Tier ($0): You can use Copilot Chat and the Workspace environment, but you are limited to 50 agent requests per month. If your README fix requires several back-and-forth "agent" steps, you might burn through your monthly quota quickly.

🔹 On the Pro Tier ($10): You get unlimited agent mode and chat using the standard models (like GPT-5 mini). This is usually the "sweet spot" for developers who want to use the "Open in Workspace" button frequently.

🔹 On Pro+ or Enterprise: You get higher priority and more "Premium Requests" to use the most advanced models (like the full Claude 3.5 Opus or GPT-5) to perform the edits.

The Verdict: You can try it for free today to see if it works for you, but if you plan on using Copilot to manage your repository tasks regularly, the $10/month Pro plan is the standard requirement.

## 1. Create the GitHub Issue for a global readme.md

Go to your repository and create a new issue. To get the best results from Copilot, be specific in your description:

Title: Fix typos and formatting in README.md

Description: > Please review the README.md file and perform the following:

🔹 Typing Errors: Scan for and fix any spelling mistakes.
🔹 Casing: Ensure proper capitalization (e.g., proper nouns, start of sentences).
🔹 Punctuation: Ensure all sentences end with a period . or appropriate punctuation.
🔹 Consistency: Standardize technical terms (e.g., ensure "GitHub" is always capitalized correctly).

![create issue](https://github.com/spawnmarvel/todo-and-current/blob/main/copilot/images/create_issue.png)

### 1.1 Create the GitHub Issue for a subfolder/readme.md

Go to your repository and create a new issue. To get the best results from Copilot, be specific in your description:

Title: Fix typos in chromebook/README.md

Description: > Please review the README.md file and perform the following:

Please review and fix the formatting for the file at:
🔹 Path: chromebook/README.md

Instructions:
🔹 Fix uppercase/lowercase for technical terms.
🔹 Ensure all sentences end with a period ..
🔹 Ignore the root README.md file; only apply changes to the one inside the chromebook folder.

## 2. Trigger the Fix (Two Methods)

Method A: Via Copilot Workspace (Recommended)
If you have Copilot Workspace enabled, you will see a button on the issue page that says "Open in Workspace."


Method B: Via VS Code (Local)

If you prefer working in your IDE:

🔹 Open your project in VS Code.

🔹Keyboard Shortcut: Press Ctrl+Alt+I (Windows/Linux) or Command+Option+I (macOS) to immediately open the Chat view in the Secondary Side Bar.

🔹 In the Copilot Chat panel, and paste the url to the issue in the chat

🔹https://github.com/spawnmarvel/py-central-monitor/issues/1

That is a clever shortcut! By pasting the direct URL into the Copilot Chat panel in VS Code, you successfully provided the "context" Copilot needed to bridge the gap between GitHub and your local files.

Looking at your latest screenshot, it worked perfectly:

🔹 What happened in your screenshot
Context Fetching: Copilot "fetched" the issue content and automatically identified that it needed to review the README.md.

Fixing in Real-Time: You can see the green (added) and red (removed) lines in your editor. It followed your instructions to a tee:

Proper Casing: It capitalized "Linux," "Zabbix," "Azure Functions," and "GitHub."

Punctuation: It added the missing periods to the ends of your sentences.

Grammar: It fixed "the repos url" to "the repository's URL."

![ai fix](https://github.com/spawnmarvel/todo-and-current/blob/main/copilot/images/ai_fix.png)

🔹 What you should do next

Now that the changes are visible in your editor but not yet "saved" to your repository:

1. Review & Keep: Look at the floating box at the bottom right of the code window. Click Keep (or press Ctrl+Enter) to accept the AI's changes into your file.

2. Commit & Push: In your VS Code terminal (which I see open at the bottom), run:

```bash
git add README.md
git commit -m "docs: fix typos and formatting per issue #1"
git push origin main
```

![close issue](https://github.com/spawnmarvel/todo-and-current/blob/main/copilot/images/close_issue.png)

3.  Close the Issue: Once you push, go back to the GitHub website and click "Close Issue" on issue #1.
## 3. Pro-Tip: Use "Agentic" Instructions

If you want Copilot to always handle README files this way without you having to repeat yourself in every issue, create a file in your repo at .github/copilot-instructions.md and add:

When editing Markdown or README files:
🔹 Always check for British vs. American spelling consistency.
🔹 Ensure every list item starts with an uppercase letter.
🔹 Ensure every sentence and bullet point ends with a period.

Now, whenever you ask Copilot to "Fix the README," it will automatically apply those rules as a background constraint.

Would you like help drafting a specific set of rules for your .github/copilot-instructions.md file?