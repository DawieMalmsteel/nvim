```python
from openai import OpenAI

client = OpenAI(
    base_url="https://models.inference.ai.azure.com/",
    api_key="YOUR_GITHUB_TOKEN" ## Thay bằng token bạn vừa tạo
)

response = client.chat.completions.create(
    messages=[{"role": "user", "content": "Say hello!"}],
    model="gpt-4o",
)
```
