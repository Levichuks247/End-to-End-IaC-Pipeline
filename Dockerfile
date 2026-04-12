# Use a specific version for stability (TPO Governance)
FROM node:18-alpine

# Security: Set a non-root user to prevent container breakouts
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

COPY package*.json ./

# Install only production dependencies to save cost/space
RUN npm install --only=production

COPY . .

# Security: Run the app as the non-root user
USER appuser

EXPOSE 80

CMD ["node", "app.js"]