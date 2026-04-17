# GitHub Copilot

##  Use case

Yes, you absolutely can. In 2026, the integration between GitHub Issues and Copilot is seamless, especially with the GitHub Copilot Workspace and the Copilot Agent features.

Here is the exact workflow to create an issue for a README.md and have Copilot fix it according to your specific instructions.

## 🔍 Is the "Fix README" feature included?

The ability to assign work to Copilot from an issue is categorized as an "Agentic" or "Workspace" feature. Here is how the cost breaks down for that specific task:

🔹 On the Free Tier ($0): You can use Copilot Chat and the Workspace environment, but you are limited to 50 agent requests per month. If your README fix requires several back-and-forth "agent" steps, you might burn through your monthly quota quickly.

🔹 On the Pro Tier ($10): You get unlimited agent mode and chat using the standard models (like GPT-5 mini). This is usually the "sweet spot" for developers who want to use the "Open in Workspace" button frequently.

🔹 On Pro+ or Enterprise: You get higher priority and more "Premium Requests" to use the most advanced models (like the full Claude 3.5 Opus or GPT-5) to perform the edits.

## 1. Create the GitHub Issue
Go to your repository and create a new issue. To get the best results from Copilot, be specific in your description:

Title: Fix typos and formatting in README.md

Description: > Please review the README.md file and perform the following:

🔹 Typing Errors: Scan for and fix any spelling mistakes.
🔹 Casing: Ensure proper capitalization (e.g., proper nouns, start of sentences).
🔹 Punctuation: Ensure all sentences end with a period . or appropriate punctuation.
🔹 Consistency: Standardize technical terms (e.g., ensure "GitHub" is always capitalized correctly).

## 2. Trigger the Fix (Two Methods)

Method A: Via Copilot Workspace (Recommended)
If you have Copilot Workspace enabled, you will see a button on the issue page that says "Open in Workspace."

🔹 Click Open in Workspace.

🔹 Copilot will automatically read your issue description and generate a Plan.

🔹 Review the plan. If it missed the "adding periods" instruction, you can refine it by typing: "Make sure you also add periods to the end of every bullet point."

🔹 Click Implement. Copilot will create a new branch and a Pull Request (PR) with all the text fixes applied.

Method B: Via VS Code (Local)

If you prefer working in your IDE:

🔹 Open your project in VS Code.

🔹 In the Copilot Chat panel, type: @github /fix #issue [issue-number]

🔹 Copilot will pull the context from that specific issue and apply the changes to your local README.md.

🔹 You can then review the diff, commit, and push.

## 3. Pro-Tip: Use "Agentic" Instructions

If you want Copilot to always handle README files this way without you having to repeat yourself in every issue, create a file in your repo at .github/copilot-instructions.md and add:

When editing Markdown or README files:
🔹 Always check for British vs. American spelling consistency.
🔹 Ensure every list item starts with an uppercase letter.
🔹 Ensure every sentence and bullet point ends with a period.

Now, whenever you ask Copilot to "Fix the README," it will automatically apply those rules as a background constraint.

Would you like help drafting a specific set of rules for your .github/copilot-instructions.md file?