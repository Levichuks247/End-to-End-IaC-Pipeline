const express = require('express');
const app = express();
const port = 5000;

app.get('/', (req, res) => {
  // We are changing the text here
  res.send('<h1>DevOps Pipeline v2.0!</h1><p>Automatic Deployment is working perfectly on AWS.</p>');
});

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});