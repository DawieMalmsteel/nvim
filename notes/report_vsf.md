- Đề bài thực hiện: Tìm hiểu về trên AWS
- Kết quả thực đạt: học và thực hành tạo cluster AWS bằng tay, học về mạng và các services trong AWS cách AWS hoạt động, và quan trọng hơn là học về billing trong aws


- Đề bài thực hiện: Tìm hiểu về terraform và các thành phần liên quan trên AWS
- Kết quả thực đạt: làm và deploy 1 cluster EC2 + tạo ra 1 mạng VPC cùng các mạng subnets public + private, đồng thời cũng tạo ra 1 NAT gateway thực tế trên AWs



- Đề bài thực hiện: Tìm hiểu về kubernetes và EKS trên AWS
- Kết quả thực đạt: Hiểu được 1 phần cách kubernetes hoạt động deploy thành công 1 web app lên EKS


- Đề bài thực hiện: Tìm hiểu về data xe tự hành của NYC và tìm cách xử lí data pipeline để clean data và tạo ra golden dataset
- Kết quả thực đạt: Clean data parquet bằng Spark sau đó lưu vào postgres để chạy dbt tiến hành export ra dataset


- Đề bài thực hiện: Tìm hiểu về data xe tự hành của NYC và tìm cách xử lí data pipeline để clean data và tạo ra golden dataset
- Kết quả thực đạt: Apply kafka và debezium để đọc bắt dữ liệu từ postgres (DB nếu chạy dự án thực tế) và tạo event cho Kafka


- Đề bài thực hiện: Tìm hiểu về data xe tự hành của NYC và tìm cách xử lí data pipeline để clean data và tạo ra golden dataset
- Kết quả thực đạt: Chuyển từ docker sang k8s (sử dụng kind)


- Đề bài thực hiện: Tìm hiểu về data xe tự hành của NYC và tìm cách xử lí data pipeline để clean data và tạo ra golden dataset
- Kết quả thực đạt: fix bug và update report và chuyển dữ liệu tĩnh từ file parquet sang lưu trong MinIO


- Đề bài thực hiện: Tìm hiểu về data xe tự hành của NYC và tìm cách xử lí data pipeline để clean data và tạo ra golden dataset
- Kết quả thực đạt: Fix bug đoạn stream data bằng debezium và kafka cải thiện hiệu suất stream để phục vụ cho việc giả lập giữ liệu hợp lí hơn


- Đề bài thực hiện: Tìm hiểu về data xe tự hành của NYC và tìm cách xử lí data pipeline để clean data và tạo ra golden dataset
- Kết quả thực đạt: Tiến hành migrate hệ thống bằng terraform chạy local bằng các sử dụng ministack để giả lập aws


- Đề bài thực hiện: Tìm hiểu về data xe tự hành của NYC và tìm cách xử lí data pipeline để clean data và tạo ra golden dataset
- Kết quả thực đạt: Loại bỏ kafka producer đọc trực tiếp file parquet vì nó không hiệu quả, giờ kafka chỉ để nhận data từ debezium 


- Đề bài thực hiện: Tìm hiểu về data xe tự hành của NYC và tìm cách xử lí data pipeline để clean data và tạo ra golden dataset
- Kết quả thực đạt: Migrate hệ thống từ dùng makefile sang sử dụng airflow để điều phối pipeline (trước đây airflow chỉ là optional) và fix lỗi spark đọc batch file (trước đây thì hệ thống phải chạy từng pods để đọc các batch file rất không ổn) giờ spark có thể đọc file batch theo group đỡ tốn tài nguyên hơn. Đồng thời cũng fix bug resource khi chạy airflow, fix lỗi MinIO không nhận file khi chạy bằng k8s


- Đề bài thực hiện: Tìm hiểu về data xe tự hành của NYC và tìm cách xử lí data pipeline để clean data và tạo ra golden dataset
- Kết quả thực đạt: Migrate hệ thống từ dùng makefile truyền thống sang dùng helm và skaffold để quản lý và điều phối k8s, chuyển airflow từ chạy docker in docker sang KubernetesPodOperator

- Đề bài thực hiện: Tìm hiểu về data xe tự hành của NYC và tìm cách xử lí data pipeline để clean data và tạo ra golden dataset
- Kết quả thực đạt: Fix bug ở spark pipeline và apply pipeline mới ở đây pipeline mới sẽ tạo ra golden dataset lưu trong minIO đồng thời cũng import vào postgres để export ra superset cho các team khác

- Đề bài thực hiện: Tìm hiểu về data xe tự hành của NYC và tìm cách xử lí data pipeline để clean data và tạo ra golden dataset
- Kết quả thực đạt: Fix bug superset để render được chart của golden dataset và sửa lại dbt để loại bỏ các edge case dữ liệu không hợp lí
