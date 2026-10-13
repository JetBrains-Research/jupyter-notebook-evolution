# Data Analytics Problem

## Description

Once upon a time, there was a popular social media platform called JetNet. JetNet was a place where people could
post short messages called "jets" to share their thoughts, ideas, and experiences with others.

JetNet had millions of users who were constantly interacting with the platform in various ways. Every time a user
performed an action on JetNet, such as liking a jet, posting a new jet, or following another user, the platform
logged that action in a text file with the following format:

```@user_id: action1 (time) -> action2 (time) -> action3 (time) -> END```

For example, if a user with ID "12345" liked a jet, posted a new jet, and then followed another user, the platform
would log the following line in the text file:

```@12345: LIKE (time) -> POST (time) -> FOLLOW (time) -> END```

Over time, JetNet accumulated a massive amount of data in this format. JetNet's data science team realized that this
data could be used to gain valuable insights into how users interact with
the platform. For example, they could analyze which actions were most popular, which users were the most active, and how
user behavior changed over time.

The hackathon problem involves working with data consisting of multiple "sessions" of different users. Each session
comprises a sequence of actions, each with its own timestamp, and the session ends with an `END` action. The task has
three stages.

### Data Engineering (30 points)

The first stage involves reading the data from a text file. The data is organized into sessions, and each session
consists of a sequence of actions. Each action has a timestamp indicating when it was executed. The goal of this stage
is to organize the data into a usable format for further analysis. Transform this data to the Pandas
DataFrame with columns  `user_id`, `session_num` (assuming that the first session by time is `0`), `action_time`,
`action_name` (20 points awarded for correct final dataset / 0 points if columns are not correct /
additional 3 point per correct filtration up to 10 additional points).

### Metrics Evaluation (40 points)

The second stage is metrics evaluation. This involves computing various metrics on the data, such as

- Mean actions count per user overall (6 points),
- Mean actions by user in a day (6 points),
- The probability of repeating the same action three times in a row during one session (6 points)
- The 0.95 quantile of distribution of time delta between the actions of the same type distribution during one session 
  (6 points).
- Is there statistical difference of activity in different days of the week? And between weekends and workdays? (6
  points)

Finally, participants should create their own unique metrics and explain why they are useful in the context of
this problem (10 points).

### Data Visualisation (30 points)

The third and final stage is data visualization. This stage involves plotting various time series and distributions of
the data, including

- the time series (line plot) of count of different actions by days (5 points),
  ![help_fig1.png](img%2Ffig1.png)
- the barchart of different actions counts (5 points),
  ![help_fig2.png](img%2Ffig3.png)
- the heatmap of `action_i`-`action_j`-`count` where `count` is a count of `action_i` right after the `action_j` (5
  points),
  ![help_fig3.png](img%2Ffig2.png)
- the time series (line plot) of all actions of the top 20 percent of active users by days (5 points).

Finally, participants should create their own data visualization of the
most interesting results that they found (10 points).

### Presentation

The participants should provide a well-documented Jupyter Notebook that must be reproducible. The notebook
should contain all the necessary code to read the data, compute the metrics, and visualize the results. The notebook
should also include a written explanation of the methodology used and any assumptions made during the analysis. The
participants should also present their solution, using the Jupyter notebook as a presentation.