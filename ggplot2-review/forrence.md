
1 - It's not always obvious what packages are used in a given chapter. For example, dplyr is attached in one of the exercises in Chapter 3 (3.5.5), and the pipe operator and print method are both used throughout the rest of the chapter. It might be a little confusing for someone new to the dplyr/tidyr/ggplot2 combo.

2 - Perhaps modify the message to include that `bins` is now a valid input as of #1158. For instance, `stat_bin()` using `bins = 30`. Pick better value with `binwidth` or `bins`.` I can make a PR if it's more convenient.

3 - Do you want to set warnings and messages to false for the entire doc, minus the times when you want to emphasize the warning/message (for instance, in 2.6.3)? It would save some space.

4 - Just a lot of little things, like commas, capitalization, etc.
      - eg. `facetting` and `faceting` are both used throughout the book, though it looks like the double t is the British English way.
      - I tend to break sentences up more. It's a preference thing, so many of those are optional.

5 - A few of the examples were broken when using previous package versions, such as the example on pg. 207 with dplyr 0.4.2. The most recent dev versions seemed to clear these up.
