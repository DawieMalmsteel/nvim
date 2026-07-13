#!/usr/bin/env bash
set -Eeuo pipefail

MMDR_BIN="$(command -v mmdr || true)"
WRAPPER_DIR="$HOME/.local/bin"
WRAPPER="$WRAPPER_DIR/mmdc"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/mmdr"
CONFIG_FILE="$CONFIG_DIR/snacks.json"

if [[ -z "$MMDR_BIN" ]]; then
  echo "Lỗi: không tìm thấy mmdr trong PATH." >&2
  exit 1
fi

mkdir -p "$WRAPPER_DIR" "$CONFIG_DIR"

# Backup wrapper/file mmdc cũ trong ~/.local/bin.
if [[ -e "$WRAPPER" && ! -f "${WRAPPER}.mmdr-wrapper" ]]; then
  BACKUP="${WRAPPER}.bak.$(date +%Y%m%d-%H%M%S)"
  mv "$WRAPPER" "$BACKUP"
  echo "Đã backup mmdc cũ: $BACKUP"
fi

cat > "$CONFIG_FILE" <<'JSON'
{
  "themeVariables": {
    "background": "#00000000"
  }
}
JSON

cat > "$WRAPPER" <<EOF
#!/usr/bin/env bash
set -Eeuo pipefail

MMDR_BIN=$(printf '%q' "$MMDR_BIN")
CONFIG_FILE=$(printf '%q' "$CONFIG_FILE")

input=""
output=""
theme="dark"

while ((\$# > 0)); do
  case "\$1" in
    -i|--input)
      input="\$2"
      shift 2
      ;;

    -o|--output)
      output="\$2"
      shift 2
      ;;

    -t|--theme)
      theme="\$2"
      shift 2
      ;;

    # Flag của mermaid-cli mà mmdr không cần.
    -b|--background|--backgroundColor|-s|--scale)
      shift 2
      ;;

    -q|--quiet)
      shift
      ;;

    --version)
      "\$MMDR_BIN" --version
      exit 0
      ;;

    *)
      echo "mmdr wrapper: bỏ qua argument không hỗ trợ: \$1" >&2
      shift
      ;;
  esac
done

[[ -n "\$input" ]] || {
  echo "mmdr wrapper: thiếu input (-i)" >&2
  exit 2
}

[[ -n "\$output" ]] || {
  echo "mmdr wrapper: thiếu output (-o)" >&2
  exit 2
}

args=(
  "\$MMDR_BIN"
  -i "\$input"
  -o "\$output"
  -e png
  -t "\$theme"
  -c "\$CONFIG_FILE"
)

# Bật bằng: export MMDR_FAST_TEXT=1
if [[ "\${MMDR_FAST_TEXT:-0}" == "1" ]]; then
  args+=(--fastText)
fi

exec "\${args[@]}"
EOF

chmod +x "$WRAPPER"
touch "${WRAPPER}.mmdr-wrapper"

echo "Wrapper đã tạo:"
echo "  $WRAPPER -> $MMDR_BIN"

TEST_DIR="$(mktemp -d)"
trap 'rm -rf "$TEST_DIR"' EXIT

cat > "$TEST_DIR/test.mmd" <<'MERMAID'
flowchart LR
    A[Snacks.image] --> B[mmdc wrapper]
    B --> C[mmdr]
    C --> D[PNG]
MERMAID

echo
echo "Đang render thử..."

START="$(date +%s%N)"

"$WRAPPER" \
  -i "$TEST_DIR/test.mmd" \
  -o "$TEST_DIR/test.png" \
  -b transparent \
  -t dark \
  -s 1

END="$(date +%s%N)"
ELAPSED_MS="$(( (END - START) / 1000000 ))"

if [[ ! -s "$TEST_DIR/test.png" ]]; then
  echo "Lỗi: không tạo được PNG." >&2
  exit 1
fi

echo
echo "Render thành công: ${ELAPSED_MS} ms"
file "$TEST_DIR/test.png"

echo
echo "Kiểm tra PATH:"
echo "  command -v mmdc: $(command -v mmdc || echo 'không tìm thấy')"
echo "  wrapper mong muốn: $WRAPPER"

if [[ "$(command -v mmdc 2>/dev/null || true)" != "$WRAPPER" ]]; then
  echo
  echo "Bạn cần đưa ~/.local/bin lên đầu PATH."
  echo
  echo 'Bash:'
  echo '  export PATH="$HOME/.local/bin:$PATH"'
  echo
  echo 'Fish:'
  echo '  fish_add_path -m ~/.local/bin'
fi

echo
echo "Sau đó restart Neovim và kiểm tra:"
echo "  :echo exepath('mmdc')"
echo "  :checkhealth snacks"
