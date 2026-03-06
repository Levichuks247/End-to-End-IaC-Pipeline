const express = require('express');
const app = express();
const port = 5000;

app.get('/', (req, res) => {
  res.send('<h1>DevOps Pipeline Successful!</h1><p>Running on AWS Elastic Beanstalk.</p>');
});

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
