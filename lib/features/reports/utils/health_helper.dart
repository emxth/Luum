String healthLabel(int score) {
  if (score >= 100) return 'Excellent';

  if (score >= 80) return 'Good';

  if (score >= 60) return 'Fair';

  if (score >= 40) return 'Poor';

  return 'Critical';
}
