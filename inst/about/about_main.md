The bed usage dashboard provides key insights into current hospital bed usage by various causes.
Currently only Flu cases are displayed, but the modular design of the data-preprocessing workflow and the Shiny application mean this app can be extended to cover other forms of illness reported through the Daily SitRep data.

## Why does this exist?

We made this as a technical exercise in creating an easy-to-maintain Shiny application following best practices,
while utilising the existing available deployment infrastructure to avoid any additional hosting costs.

You can see other examples of our work in our [dashboard gallery](https://www.jumpingrivers.com/data-science/gallery/).

## Where did the idea come from?

This is not the first app to track bed usage from seasonal illnesses.
The original inspiration came from a ['flu-tracker Shiny application](https://nhsml-nuct.shinyapps.io/NationalFlu/) ([source code](https://github.com/MLCSU/NationalFlu)) created by the DS Team within NUCT at NHS ML.
Since the development of this application, the author of the original application has announced his retirement, meaning that application is looking for a new maintainer and host.
We wish Andy McCann all the best in his retirement and thank him for the inspiration to this version of the application.

## So what was the aim of this application?

We wanted to take the original 'flu-tracker application as inspiration and make a new version from
scratch, along the way demonstrating best practices for making an efficient, low-maintenance Shiny application.
Our main aims were to:

- Use modern {bslib} layouts that enable easy branding through *_brand.yml* files.
- Avoid inputs that can cause keyboard navigation issues to meet more WCAG 2.1 AA standards.
- Create a maintainable modular codebase, that can easily extend to more illnesses than just the 'flu dataset.
- Implement pipelines to automatically prepare and quality-check data from original sources to:
    - Reduce application loading times and computational load,
    - Provide immediate alerts when incoming data does not meet the expected standards,
    - Provide resiliance to the original dataset becoming unavailable in the future.

We also self-imposed a requirement to only use our existing infrastructure, without the need to setup any extra resources or incur any additional costs.
This is to recreate the scenario many Data Science teams face on most days---aiming to produce and deliver their work using only what's already available to them, while trying to reduce the burden of requesting more help from their IT departments.

- All development was performed exclusively on our Posit Workbench server.
- Code storage was handled by our existing Git provider.
- The hosting of the application and scheduled pre-processing pipeline are performed on our Posit Connect server.

If you're interested in providing your Data Science team with the tools they need to work freely, we can help [setup Posit infrastructure for your enterprise](https://www.jumpingrivers.com/posit/license-resale/).
